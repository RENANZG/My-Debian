import fitz
import img2pdf
from pathlib import Path
import tkinter as tk
from tkinter import filedialog, messagebox, ttk, scrolledtext
import threading

class PDFSanitizerApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("PDFGuard")
        self.geometry("700x500")
        self.setup_ui()

    def setup_ui(self):
        frame = tk.Frame(self, padx=20, pady=20)
        frame.pack(fill=tk.BOTH, expand=1)

        self.input_entry = self.create_input_frame(frame)
        self.output_entry = self.create_output_frame(frame)
        self.create_process_button(frame)
        self.create_progress(frame)
        self.logger = self.create_logger(frame)

    def create_input_frame(self, parent):
        frame = self.build_frame(parent, "Input PDF Files:")
        entry = tk.Entry(frame, width=60)
        entry.pack(side=tk.LEFT, fill=tk.X, expand=1)
        tk.Button(frame, text="Browse", command=self.select_input_files).pack(side=tk.LEFT, padx=5)
        return entry

    def create_output_frame(self, parent):
        frame = self.build_frame(parent, "Output Folder:")
        entry = tk.Entry(frame, width=60)
        entry.pack(side=tk.LEFT, fill=tk.X, expand=1)
        tk.Button(frame, text="Browse", command=self.select_output_folder).pack(side=tk.LEFT, padx=5)
        return entry

    def build_frame(self, parent, label_text):
        frame = tk.Frame(parent)
        frame.pack(fill=tk.X, pady=5)
        tk.Label(frame, text=label_text).pack(side=tk.LEFT)
        return frame

    def create_process_button(self, parent):
        tk.Button(parent, text="Sanitize PDF", command=self.process_pdf).pack(pady=10)

    def create_progress(self, parent):
        self.current_file_label = tk.Label(parent, text="")
        self.current_file_label.pack(pady=5)
        self.progress = ttk.Progressbar(parent, orient=tk.HORIZONTAL, length=300, mode="determinate")
        self.progress.pack(pady=5, fill=tk.X)

    def create_logger(self, parent):
        logger = scrolledtext.ScrolledText(parent, height=10, wrap=tk.WORD, state=tk.DISABLED)
        logger.pack(pady=10, fill=tk.BOTH, expand=1)
        return logger

    def select_input_files(self):
        files_path = filedialog.askopenfilenames(filetypes=[("PDF files", "*.pdf")])
        self.input_entry.delete(0, tk.END)
        # Using a different delimiter ('|') to split multiple files
        self.input_entry.insert(0, '|'.join(files_path))

    def select_output_folder(self):
        folder_path = filedialog.askdirectory()
        self.output_entry.delete(0, tk.END)
        self.output_entry.insert(0, folder_path)

    def process_pdf(self):
        # Using the '|' delimiter to split the files
        files = [file.strip() for file in self.input_entry.get().split('|')]
        self.progress["maximum"] = len(files)
        self.progress["value"] = 0
        threading.Thread(target=self.sanitize_pdf, args=(files,)).start()

    def sanitize_pdf(self, input_files):
        output_folder = self.output_entry.get()
        error_messages = []
        for input_filename in input_files:
            input_path = Path(input_filename)
            self.current_file_label.config(text=f"Processing: {input_path.name}")
            self.update_idletasks()
            try:
                with fitz.open(input_path) as doc:
                    images = [page.get_pixmap(matrix=fitz.Matrix(150/72, 150/72)).tobytes() for page in doc]
                    output_pdf_filename = Path(output_folder) / f"sanitized_{input_path.stem}.pdf"
                    if output_pdf_filename.exists():
                        result = messagebox.askyesno("Warning", f"The output file {output_pdf_filename} already exists. Do you want to overwrite?")
                        if not result:
                            continue
                    with open(output_pdf_filename, "wb") as output_pdf:
                        output_pdf.write(img2pdf.convert(images))
                    self.log(f"Successfully sanitized {input_filename} to {output_pdf_filename}")
            except Exception as e:
                error_messages.append(f"Error processing {input_filename}: {str(e)}")
            self.progress["value"] += 1
            self.update_idletasks()
        self.current_file_label.config(text="")
        if error_messages:
            messagebox.showerror("Errors Encountered", "\n".join(error_messages))
        else:
            messagebox.showinfo("Completed", "All files processed successfully!")

    def log(self, msg):
        self.logger.configure(state=tk.NORMAL)
        self.logger.insert(tk.END, msg + "\n")
        self.logger.see(tk.END)
        self.logger.configure(state=tk.DISABLED)

app = PDFSanitizerApp()
app.mainloop()
