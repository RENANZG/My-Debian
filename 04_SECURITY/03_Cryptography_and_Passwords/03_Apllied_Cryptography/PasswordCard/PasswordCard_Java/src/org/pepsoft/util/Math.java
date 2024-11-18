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

public final class Math {
    private Math() {
        // Prevent instantiation
    }
    
    /**
     * Returns the result of n modulo m.
     * 
     * @param n The first operand
     * @param m The second operand
     * @return n modulo m
     */
    public static int mod(int n, int m) {
        if ((n % m) == 0) {
            return 0;
        } else if (n >= 0) {
            return n % m;
        } else {
            return m + (n % m);
        }
    }
}