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

package org.pepsoft.util;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import org.pepsoft.passwordcard.PasswordCard;

/**
 * A simple command line tool to generate PasswordCards.
 *
 * @author pepsoft.org
 */
public class Tool {
    public static void main(String[] args) throws IOException {
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out), true, "UTF-8"));

        long seed = parseUnsignedHexLong(args[0]);
        boolean digitArea = false;
        boolean includeSymbols = false;
        for (int i = 1; i < args.length; i++) {
            if (args[i].equals("--digitArea")) {
                digitArea = true;
            } else if (args[i].equals("--includeSymbols")) {
                includeSymbols = true;
            } else {
                throw new IllegalArgumentException(args[i]);
            }
        }
        PasswordCard passwordCard = new PasswordCard(seed, digitArea, includeSymbols);
        for (char[] row: passwordCard.getGrid()) {
            System.out.println(row);
        }
    }

    private static long parseUnsignedHexLong(String str) {
        str = str.trim();
        if (str.length() > 16) {
            throw new IllegalArgumentException();
        }
        StringBuilder sb = new StringBuilder(16);
        for (int i = str.length(); i < 16; i++) {
            sb.append('0');
        }
        sb.append(str);
        String paddedStr = sb.toString();
        return Long.parseLong(paddedStr.substring(0, 8), 16) << 32 | Long.parseLong(paddedStr.substring(8), 16);
    }
}