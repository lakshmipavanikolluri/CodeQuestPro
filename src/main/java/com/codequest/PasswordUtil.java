
package com.codequest;

import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    private static final int ITERATIONS = 210000;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;

    public static String hashPassword(String password)
            throws Exception {

        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException(
                "Password cannot be empty.");
        }

        byte[] salt = new byte[SALT_LENGTH];
        new SecureRandom().nextBytes(salt);

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(),
            salt,
            ITERATIONS,
            KEY_LENGTH
        );

        try {
            byte[] hash = SecretKeyFactory
                .getInstance("PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();

            return ITERATIONS + ":"
                + Base64.getEncoder().encodeToString(salt) + ":"
                + Base64.getEncoder().encodeToString(hash);

        } finally {
            spec.clearPassword();
        }
    }

    public static boolean verifyPassword(
            String password, String storedHash)
            throws Exception {

        if (password == null || storedHash == null) {
            return false;
        }

        String[] parts = storedHash.split(":", -1);

        if (parts.length != 3) {
            return false;
        }

        int iterations;
        byte[] salt;
        byte[] expectedHash;

        try {
            iterations = Integer.parseInt(parts[0]);
            salt = Base64.getDecoder().decode(parts[1]);
            expectedHash = Base64.getDecoder().decode(parts[2]);

        } catch (IllegalArgumentException e) {
            return false;
        }

        if (iterations < 1 || iterations > 1000000
                || salt.length != SALT_LENGTH
                || expectedHash.length != KEY_LENGTH / 8) {
            return false;
        }

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(),
            salt,
            iterations,
            expectedHash.length * 8
        );

        try {
            byte[] actualHash = SecretKeyFactory
                .getInstance("PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();

            if (actualHash.length != expectedHash.length) {
                return false;
            }

            int difference = 0;

            for (int i = 0; i < actualHash.length; i++) {
                difference |= actualHash[i] ^ expectedHash[i];
            }

            return difference == 0;

        } finally {
            spec.clearPassword();
        }
    }
}
