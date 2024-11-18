<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Comparison: Sway, Polybar, and LXQt</title>
<style>
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: left;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th, td {
            padding: 10px;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
</style>
</head>
<body>

<h2>Comparison of Sway, Polybar, and LXQt</h2>

<table>
    <thead>
        <tr>
            <th>Feature</th>
            <th>Sway</th>
            <th>Polybar</th>
            <th>LXQt</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Type</td>
            <td>Wayland Compositor</td>
            <td>Customizable Status Bar</td>
            <td>Desktop Environment</td>
        </tr>
        <tr>
            <td>Primary Use</td>
            <td>Window manager for Wayland</td>
            <td>Bar for X11/Wayland window managers</td>
            <td>Lightweight desktop environment</td>
        </tr>
        <tr>
            <td>Supported Platforms</td>
            <td>Wayland</td>
            <td>X11, Wayland</td>
            <td>X11 (limited Wayland support)</td>
        </tr>
        <tr>
            <td>Customizability</td>
            <td>Highly customizable with config files</td>
            <td>Highly customizable with modules and config</td>
            <td>Customizable with themes and various components</td>
        </tr>
        <tr>
            <td>Appearance</td>
            <td>Minimalist, keyboard-driven workflow</td>
            <td>Customizable (various themes can be applied)</td>
            <td>Traditional desktop look (lightweight)</td>
        </tr>
        <tr>
            <td>Dependency</td>
            <td>Requires Wayland</td>
            <td>Requires X11 or Wayland</td>
            <td>Requires Qt libraries</td>
        </tr>
        <tr>
            <td>Configuration File</td>
            <td>Config file (`~/.config/sway/config`)</td>
            <td>Config file (`~/.config/polybar/config`)</td>
            <td>Graphical configuration tool</td>
        </tr>
        <tr>
            <td>Community & Support</td>
            <td>Active, growing community</td>
            <td>Active, widely used for custom bar setups</td>
            <td>Large community but less active than popular DEs</td>
        </tr>
        <tr>
            <td>Display Server</td>
            <td>Wayland</td>
            <td>X11, Wayland</td>
            <td>X11 (limited Wayland support)</td>
        </tr>
        <tr>
            <td>Window Manager</td>
            <td>Wayland (tiling window manager)</td>
            <td>Works with X11 and Wayland window managers (e.g., i3, Sway)</td>
            <td>None (LXQt is a full DE)</td>
        </tr>
        <tr>
            <td>Display Manager</td>
            <td>Works with any display manager</td>
            <td>Works with any display manager</td>
            <td>Compatible with display managers like SDDM, LightDM</td>
        </tr>
        <tr>
            <td>Compositor</td>
            <td>Sway is a Wayland compositor</td>
            <td>None (Polybar is not a compositor)</td>
            <td>Works with X11 compositors (e.g., Picom, Compton)</td>
        </tr>
        <tr>
            <td>Widget Toolkit</td>
            <td>None (Wayland clients)</td>
            <td>None (interacts with various toolkits like GTK or Qt)</td>
            <td>Qt</td>
        </tr>
    </tbody>
</table>

</body>
</html>
