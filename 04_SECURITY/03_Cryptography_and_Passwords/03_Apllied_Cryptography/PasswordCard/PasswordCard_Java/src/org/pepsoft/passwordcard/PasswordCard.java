/*
 * This file is part of PasswordCard.
 *
 * PasswordCard is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PasswordCard is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PasswordCard.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright © 2010 pepsoft.org.
 */

package org.pepsoft.passwordcard;

import java.security.SecureRandom;
import java.util.Random;

import org.pepsoft.util.Math;

/**
 * A uniquely numbered PasswordCard.
 * 
 * @author pepsoft.org
 */
public class PasswordCard {
    /**
     * Create a new PasswordCard with a specific number and specific options.
     *
     * @param number The serial number or seed of the card.
     * @param digitArea Whether to include an area containing only digits.
     * @param includeSymbols Whether to include symbols.
     */
    public PasswordCard(long number, boolean digitArea, boolean includeSymbols) {
        this.number = number;
        this.digitArea = digitArea;
        this.includeSymbols = includeSymbols;
    }

    /**
     * Get the card serial number or seed.
     *
     * @return The card serial number or seed.
     */
    public long getNumber() {
        return number;
    }

    /**
     * Get the contents of the card as a two dimensional array of characters.
     *
     * @return The contents of the card.
     */
    public synchronized char[][] getGrid() {
        if (grid == null) {
            generateGrid();
        }
        return grid;
    }

    /**
     * Get the contents of the card as a string containing multiple lines, using
     * the specified EOL sequence. Each line except the header will have a line
     * number (starting with 1) appended.
     *
     * @param eol The EOL sequence to use.
     * @return The contents of the card in string format.
     */
    public String getAsString(String eol) {
        StringBuilder sb = new StringBuilder(HEIGHT * (WIDTH + eol.length() + 1) - 1);
        char[][] myGrid = getGrid();
        for (int y = 0; y < myGrid.length; y++) {
            sb.append(myGrid[y]);
            if (y > 0) {
                sb.append(y);
            }
            sb.append(eol);
        }
        return sb.toString();
    }

    /**
     * Get a character from the symbol row or header at a specific column.
     *
     * @param x The column index. This may be less then zero or larger than the
     *     width of the card, in which case it will automatically "wrap around".
     * @return The character in the symbol row or header at the specified
     *     column.
     */
    public synchronized char charAtHeader(int x) {
        if (grid == null) {
            generateGrid();
        }
        return grid[0][Math.mod(x, WIDTH)];
    }
    
    /**
     * Get a character from the body of the card at specific coordinates. Note
     * that this method does not return characters from the symbol row or
     * header, and row zero refers to the topmost row of the body of the card.
     *
     * @param x The column index. This may be less then zero or larger than the
     *     width of the card, in which case it will automatically "wrap around".
     * @param x The row index. Row zero is the topmost row of the body of the
     *     card. This may be less then zero or larger than the height the card,
     *     in which case it will automatically "wrap around".
     * @return The character at the specified coordinates of the body of the
     *     card.
     */
    public synchronized char charAtBody(int x, int y) {
        if (grid == null) {
            generateGrid();
        }
        return grid[Math.mod(y, BODY_HEIGHT) + 1][Math.mod(x, WIDTH)];
    }

    /**
     * Create a new card with a randomly chosen number. A secure random number
     * generator is used so that the card number is truly random.
     *
     * @param digitArea Whether to include an area containing only digits.
     * @param includeSymbols Whether to include symbols.
     * @return A new card with the specified options and a randomly chosen
     *     number.
     */
    public static PasswordCard createRandomCard(boolean digitArea,
            boolean includeSymbols) {
        return new PasswordCard(cardCreationRandomiser.nextLong(), digitArea,
                includeSymbols);
    }

    private void generateGrid() {
        grid = new char[HEIGHT][WIDTH];
        Random random = new Random(number);
        char[] headerChars = HEADER_CHARS.toCharArray();
        shuffle(headerChars, random);
        if (headerChars.length > WIDTH) {
            char[] tmp = headerChars;
            headerChars = new char[WIDTH];
            System.arraycopy(tmp, 0, headerChars, 0, WIDTH);
        }
        grid[0] = headerChars;

        if (digitArea) {
            int halfHeight = 1 + ((HEIGHT - 1) / 2);
            for (int y = 1; y < halfHeight; y++) {
                for (int x = 0; x < WIDTH; x++) {
                    if (includeSymbols && ((x % 2) == 0)) {
                        grid[y][x] = DIGITS_LETTERS_AND_SYMBOLS.charAt(random
                                .nextInt(DIGITS_LETTERS_AND_SYMBOLS.length()));
                    } else {
                        grid[y][x] = DIGITS_AND_LETTERS.charAt(random
                                .nextInt(DIGITS_AND_LETTERS.length()));
                    }
                }
            }
            for (int y = halfHeight; y < HEIGHT; y++) {
                for (int x = 0; x < WIDTH; x++) {
                    grid[y][x] = DIGITS.charAt(random.nextInt(10));
                }
            }
        } else {
            for (int y = 1; y < HEIGHT; y++) {
                for (int x = 0; x < WIDTH; x++) {
                    if (includeSymbols && ((x % 2) == 0)) {
                        grid[y][x] = DIGITS_LETTERS_AND_SYMBOLS.charAt(random
                                .nextInt(DIGITS_LETTERS_AND_SYMBOLS.length()));
                    } else {
                        grid[y][x] = DIGITS_AND_LETTERS.charAt(random
                                .nextInt(DIGITS_AND_LETTERS.length()));
                    }
                }
            }
        }
    }

    /**
     * Private implementation of Collections.shuffle() algorithm, because the
     * Android core classes implement it differently.
     * 
     * @param list
     *            The list of characters to shuffle.
     * @param rnd
     *            The pseudorandom generator instance to use for the shuffle.
     */
    private void shuffle(char[] list, Random rnd) {
        int size = list.length;
        for (int i = size; i > 1; i--)
            swap(list, i - 1, rnd.nextInt(i));
    }

    private void swap(char[] list, int i, int j) {
        char tmp = list[i];
        list[i] = list[j];
        list[j] = tmp;
    }

    private final long number;
    private final boolean digitArea, includeSymbols;
    private char[][] grid;

    public static final int WIDTH = 29, HEIGHT = 9, BODY_HEIGHT = HEIGHT - 1;

    private static final String HEADER_CHARS = "■□▲△○●★☂☀☁☹☺♠♣♥♦♫€¥£$!?¡¿⊙◐◩�";
    private static final String DIGITS = "0123456789";
    private static final String DIGITS_AND_LETTERS = "23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
    private static final String DIGITS_LETTERS_AND_SYMBOLS = "23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ@#$%&*<>?€+{}[]()/\\";
    private static final Random cardCreationRandomiser = new SecureRandom();
}