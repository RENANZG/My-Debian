<table class="s-table">
<thead>
<tr>
<th>#</th>
<th>Expression</th>
<th>Result</th>
<th>Comments</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td><code>"$a"</code></td>
<td><code>apple</code></td>
<td>variables are expanded inside <code>""</code></td>
</tr>
<tr>
<td>2</td>
<td><code>'$a'</code></td>
<td><code>$a</code></td>
<td>variables are not expanded inside <code>''</code></td>
</tr>
<tr>
<td>3</td>
<td><code>"'$a'"</code></td>
<td><code>'apple'</code></td>
<td><code>''</code> has no special meaning inside <code>""</code></td>
</tr>
<tr>
<td>4</td>
<td><code>'"$a"'</code></td>
<td><code>"$a"</code></td>
<td><code>""</code> is treated literally inside <code>''</code></td>
</tr>
<tr>
<td>5</td>
<td><code>'\''</code></td>
<td><strong>invalid</strong></td>
<td>can not escape a <code>'</code> within <code>''</code>; use <code>"'"</code> or <code>$'\''</code> (ANSI-C quoting)</td>
</tr>
<tr>
<td>6</td>
<td><code>"red$arocks"</code></td>
<td><code>red</code></td>
<td><code>$arocks</code> does not expand <code>$a</code>; use <code>${a}rocks</code> to preserve <code>$a</code></td>
</tr>
<tr>
<td>7</td>
<td><code>"redapple$"</code></td>
<td><code>redapple$</code></td>
<td><code>$</code> followed by no variable name evaluates to <code>$</code></td>
</tr>
<tr>
<td>8</td>
<td><code>'\"'</code></td>
<td><code>\"</code></td>
<td><code>\</code> has no special meaning inside <code>''</code></td>
</tr>
<tr>
<td>9</td>
<td><code>"\'"</code></td>
<td><code>\'</code></td>
<td><code>\'</code> is interpreted inside <code>""</code> but has no significance for <code>'</code></td>
</tr>
<tr>
<td>10</td>
<td><code>"\""</code></td>
<td><code>"</code></td>
<td><code>\"</code> is interpreted inside <code>""</code></td>
</tr>
<tr>
<td>11</td>
<td><code>"*"</code></td>
<td><code>*</code></td>
<td>glob does not work inside <code>""</code> or <code>''</code></td>
</tr>
<tr>
<td>12</td>
<td><code>"\t\n"</code></td>
<td><code>\t\n</code></td>
<td><code>\t</code> and <code>\n</code> have no special meaning inside <code>""</code> or <code>''</code>; use ANSI-C quoting</td>
</tr>
<tr>
<td>13</td>
<td><code>"`echo hi`"</code></td>
<td><code>hi</code></td>
<td><code>``</code> and <code>$()</code> are evaluated inside <code>""</code> (backquotes are retained in actual output)</td>
</tr>
<tr>
<td>14</td>
<td><code>'`echo hi`'</code></td>
<td><code>`echo hi`</code></td>
<td><code>``</code> and <code>$()</code> are not evaluated inside <code>''</code> (backquotes are retained in actual output)</td>
</tr>
<tr>
<td>15</td>
<td><code>'${arr[0]}'</code></td>
<td><code>${arr[0]}</code></td>
<td>array access not possible inside <code>''</code></td>
</tr>
<tr>
<td>16</td>
<td><code>"${arr[0]}"</code></td>
<td><code>apple</code></td>
<td>array access works inside <code>""</code></td>
</tr>
<tr>
<td>17</td>
<td><code>$'$a\''</code></td>
<td><code>$a'</code></td>
<td>single quotes can be escaped inside ANSI-C quoting</td>
</tr>
<tr>
<td>18</td>
<td><code>"$'\t'"</code></td>
<td><code>$'\t'</code></td>
<td>ANSI-C quoting is not interpreted inside <code>""</code></td>
</tr>
<tr>
<td>19</td>
<td><code>'!cmd'</code></td>
<td><code>!cmd</code></td>
<td>history expansion character <code>'!'</code> is ignored inside <code>''</code></td>
</tr>
<tr>
<td>20</td>
<td><code>"!cmd"</code></td>
<td><code>cmd args</code></td>
<td>expands to the most recent command matching <code>"cmd"</code></td>
</tr>
<tr>
<td>21</td>
<td><code>$'!cmd'</code></td>
<td><code>!cmd</code></td>
<td>history expansion character <code>'!'</code> is ignored inside ANSI-C quotes</td>
</tr>
</tbody>
</table>
