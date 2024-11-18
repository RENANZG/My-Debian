<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Concepts of Digital Files</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
            text-align: left;
        }
    </style>
</head>
<body>
    <h1>Concepts of Digital Files</h1>
    <table>
        <thead>
            <tr>
                <th>Concept</th>
                <th>Definition</th>
                <th>Examples</th>
                <th>Special System Details</th>
            </tr>
        </thead>
        <tbody>
            <!-- General File Information -->
            <tr>
                <td>File</td>
                <td>A collection of data or information stored on a computer, typically identified by a name and a file extension. Files can be human-readable or machine-readable.</td>
                <td>Document, image, video, executable program, database</td>
                <td>File extensions help identify file types, but actual file format information is stored within the file.</td>
            </tr>
            <tr>
                <td>Human-Readable File</td>
                <td>A file that contains data in a format that can be easily read and understood by humans, often using character encodings.</td>
                <td>.txt, .html, .md</td>
                <td>On macOS, file extensions such as .txt or .html are used; Windows also uses extensions like .docx or .xlsx.</td>
            </tr>
            <tr>
                <td>Machine-Readable File</td>
                <td>A file that contains data in a format that is primarily intended for machine processing, not easily interpretable by humans.</td>
                <td>.exe, .bin, .dat</td>
                <td>Windows executable files (.exe) and binary files (.bin) are examples; macOS has .app bundles.</td>
            </tr>
            <!-- File Types -->
            <tr>
                <td>Text File</td>
                <td>A type of human-readable file that contains plain text and is usually encoded in a character encoding format.</td>
                <td>.txt, .html, .css, .js</td>
                <td>Unix-like systems and macOS use plain text files with extensions like .txt; Windows uses .log and .csv.</td>
            </tr>
            <tr>
                <td>Binary File</td>
                <td>A file that contains data in binary format, encoded in a series of 0s and 1s. This data is often used for executable files or compiled code.</td>
                <td>.exe, .bin, .o, .dll</td>
                <td>Binary files on UNIX may not have specific extensions, but Windows uses .dll and .sys for dynamic libraries and system files.</td>
            </tr>
            <tr>
                <td>Executable File</td>
                <td>A type of binary file that contains a program capable of being executed by the operating system.</td>
                <td>.exe (Windows), .app (macOS), .out (Linux)</td>
                <td>Windows executable files (.exe); macOS uses .app bundles; Linux uses .out or no extension for executables.</td>
            </tr>
            <tr>
                <td>Script</td>
                <td>A text file containing a series of commands or code written in a scripting language, executed by an interpreter or shell.</td>
                <td>.sh (shell script), .py (Python script), .js (JavaScript file), .bat (batch file)</td>
                <td>Scripts on UNIX-like systems use .sh, .py; Windows uses .bat and .ps1 for PowerShell scripts.</td>
            </tr>
            <tr>
                <td>Configuration File</td>
                <td>A file used to configure the settings and preferences of software applications and operating systems, often in text format.</td>
                <td>.ini, .cfg, .conf, .xml, .json</td>
                <td>Configuration files on UNIX systems include .conf; Windows uses .ini and .xml files for settings.</td>
            </tr>
            <!-- File Encoding & Multimedia -->
            <tr>
                <td>File Encoding</td>
                <td>The method used to convert text data into bytes for storage and interpretation. It ensures correct display of characters.</td>
                <td>UTF-8, ASCII, Base64</td>
                <td>File encoding is generally not system-specific, but text files are encoded using these formats across all platforms.</td>
            </tr>
            <tr>
                <td>Codec</td>
                <td>A technology or algorithm used to compress and decompress multimedia data. Codecs manage how data is encoded for storage or transmission and decoded for playback.</td>
                <td>H.264 (video), MP3 (audio), AAC (audio)</td>
                <td>Codecs are standardized across systems, but specific implementations may vary between platforms.</td>
            </tr>
            <tr>
                <td>File Container</td>
                <td>A file format that encapsulates encoded multimedia data along with metadata and possibly multiple streams of data.</td>
                <td>MP4, MKV, AVI</td>
                <td>Containers are platform-independent, but may have different software tools for manipulation on various OSs.</td>
            </tr>
            <!-- Reverse Engineering and Digital Forensics -->
            <tr>
                <td>File Signature (Magic Number)</td>
                <td>A unique sequence of bytes located at the beginning of a file used to identify its type or format.</td>
                <td>0xFFD8FFE0 (JPEG), 0x504B0304 (ZIP)</td>
                <td>Used across UNIX-like systems to identify file types using the "file" command. Examples: 0x7F454C46 (ELF), 0x4D5A (PE). </td>
            </tr>
            <tr>
                <td>Metadata</td>
                <td>Data that provides information about other data, including file attributes like creation date and author.</td>
                <td>EXIF data in images, file properties in Windows</td>
                <td>Metadata is stored differently across file systems but provides essential informations.</td>
            </tr>
            <tr>
                <td>File Header</td>
                <td>The part of a file that contains metadata about the file, such as format, version, and size.</td>
                <td>PE header in Windows executables, ELF header in Linux executables</td>
                <td>File headers are used by operating systems to interpret file content and structure.</td>
            </tr>
            <tr>
                <td>Hex Editor</td>
                <td>A tool for viewing and editing the raw binary data of a file.</td>
                <td>HxD, Hex Fiend</td>
                <td>Hex editors are essential for examining and manipulating binary data directly.</td>
            </tr>
            <tr>
                <td>Disassembler</td>
                <td>A tool that translates machine code back into assembly language for analysis and understanding of executable files.</td>
                <td>IDA Pro, Ghidra</td>
                <td>Disassemblers are used in reverse engineering to analyze binary code and understand program behavior.</td>
            </tr>
            <tr>
                <td>Debugger</td>
                <td>A tool for executing code step-by-step and examining the state of a program in real-time.</td>
                <td>OllyDbg, x64dbg</td>
                <td>Debuggers are used to analyze and modify the execution of programs for troubleshooting and analysis.</td>
            </tr>
            <tr>
                <td>Memory Dump</td>
                <td>A snapshot of the contents of a computer’s memory.</td>
                <td>Full memory dump, crash dump</td>
                <td>Memory dumps provide insights into active processes and potential security threats.</td>
            </tr>
        </tbody>
    </table>
</body>
</html>
