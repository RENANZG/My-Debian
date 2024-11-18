<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>How to Install Python 3 and Set Up a Programming Environment on Debian</title>
 </head>
 <body>

  <h1>Python Development Setup</h1>

   <h2>Step 1 — Setting Up Python 3</h2>
  
   <p>
    Debian Linux ships with both Python 3 and Python 2 pre-installed. To make
    sure that our versions are up-to-date, let’s update and upgrade the system
    with the apt command to work with the Advanced Packaging Tool:
   </p>

   <pre><code>
   sudo apt update
   sudo apt -y upgrade
   </code></pre>
   
   <p>
    The <code>-y</code> flag will confirm that we are agreeing for all items to
    be installed.
   </p>
   
   <p>
    Once the process is complete, we can check the version of Python 3 that is
    installed in the system by typing:
   </p>

   <pre><code>python3 -V</code></pre>
   
   <p>
    You’ll receive output in the terminal window that will let you know the
    version number. While this number may vary, the output will be similar to
    this:
   </p>

   <pre><code>
   Output
   Python 3.7.3
   </code></pre>
   
   <p>
    To manage software packages for Python, install pip, a tool that will install and manage programming packages we may want to use in our development projects.”
   </p>

   <pre><code>sudo apt install -y python3-pip</code></pre>

   <h3>Python - Virtualenv</h3>
   
   <pre><code>virtualenv -p python3 [name]</code></pre>
   
   <p>Creating a new environment</p>
   
   <pre><code>source [name]/bin/activate</code></pre>
   
   <p>Activate env</p>
   <p>Python packages can be installed by typing:</p>
   
   <pre><code>pip3 install package_name</code></pre>
   
   <p>
    Here, <code>package_name</code> can refer to any Python package or library,
    such as Django for web development or NumPy for scientific computing. So if
    you would like to install NumPy, you can do so with the command
    <code>pip3 install numpy</code>.
   </p>
   
   <p>
    There are a few more packages and development tools to install to ensure
    that we have a robust set-up for our programming environment:
   </p>

   <pre><code>sudo apt install build-essential libssl-dev libffi-dev python3-dev</code></pre>
   
   <p>
    Once Python is set up, and pip and other tools are installed, we can set up
    a virtual environment for our development projects.
   </p>

   <h2>Step 2 — Setting Up a Virtual Environment</h2>
   
   <p>
    Virtual environments enable you to have an isolated space on your server for
    Python projects, ensuring that each of your projects can have its own set of
    dependencies that won’t disrupt any of your other projects.
   </p>
   
   <p>
    Setting up a programming environment provides us with greater control over
    our Python projects and over how different versions of packages are handled.
    This is especially important when working with third-party packages.
   </p>
   
   <p>
    You can set up as many Python programming environments as you want. Each
    environment is basically a directory or folder on your server that has a few
    scripts in it to make it act as an environment.
   </p>
   
   <p>
    While there are a few ways to achieve a programming environment in Python,
    we’ll be using the venv module here, which is part of the standard Python 3
    library. Let’s install venv by typing:
   </p>

   <pre><code>sudo apt install -y python3-venv</code></pre>
   
   <p>
    With this installed, we are ready to create environments. Let’s either
    choose which directory we would like to put our Python programming
    environments in, or create a new directory with <code>mkdir</code>, as in:
   </p>

   <pre><code>
   mkdir environments
   cd environments
   </code></pre>
   
   <p>
    Once you are in the directory where you would like the environments to live,
    you can create an environment by running the following command:
   </p>

   <pre><code>python3.7 -m venv my_env</code></pre>
   
   <p>
    Essentially, pyvenv sets up a new directory that contains a few items which
    we can view with the <code>ls</code> command:
   </p>

   <pre><code>ls my_env</code></pre>
   <pre><code>
   Output
   bin include lib lib64 pyvenv.cfg share
   </code></pre>
   
   <p>
    Together, these files work to make sure that your projects are isolated from
    the broader context of your local machine, so that system files and project
    files don’t mix. This is good practice for version control and to ensure
    that each of your projects has access to the particular packages that it
    needs. Python Wheels, a built-package format for Python that can speed up
    your software production by reducing the number of times you need to
    compile, will be in the Debian share directory.
   </p>
   
   <p>
    To use this environment, you need to activate it, which you can achieve by
    typing the following command that calls the activate script:
   </p>

   <pre><code>source my_env/bin/activate</code></pre>
   
   <p>
    Your command prompt will now be prefixed with the name of your environment,
    in this case it is called my_env. Depending on what version of Debian Linux
    you are running, your prefix may appear somewhat differently, but the name
    of your environment in parentheses should be the first thing you see on your
    line:
   </p>

   <pre><code>(my_env)user@hostname:~$</code></pre>
   
   <p>
    This prefix lets us know that the environment my_env is currently active,
    meaning that when we create programs here they will use only this particular
    environment’s settings and packages.
   </p>
   
   <p>
    <strong>Note:</strong> Within the virtual environment, you can use the
    command <code>python</code> instead of <code>python3</code>, and
    <code>pip</code> instead of <code>pip3</code> if you would prefer. If you
    use Python 3 on your machine outside of an environment, you will need to use
    the <code>python3</code> and <code>pip3</code> commands exclusively.
   </p>
   
   <p>After following these steps, your virtual environment is ready to use.</p>

   <h2>Step 3 — Creating a “Hello, World” Program</h2>
   
   <p>
    Now that we have our virtual environment set up, let’s create a traditional
    “Hello, World!” program. This will let us test our environment and provides
    us with the opportunity to become more familiar with Python if we aren’t
    already.
   </p>
   
   <p>
    To do this, we’ll open up a command-line text editor such as nano and create
    a new file:
   </p>

   <pre><code>nano hello.py</code></pre>
   
   <p>
    Once the text file opens up in the terminal window we’ll type out our
    program:
   </p>

   <pre><code>print("Hello, World!")</code></pre>
   
   <p>
    Exit nano by typing the <code>CTRL</code> and <code>X</code> keys, and when
    prompted to save the file press <code>y</code>.
   </p>
   
   <p>
    Once you exit out of nano and return to your shell, let’s run the program:
   </p>

   <pre><code>python hello.py</code></pre>
   
   <p>
    The hello.py program that you just created should cause your terminal to
    produce the following output:
   </p>

   <pre><code>
   Output
   Hello, World!
   </code></pre>
   
   <p>
    To leave the environment, simply type the command
    <code>deactivate</code> and you will return to your original directory.
   </p>

   <h3>Python - Linting - VSCodium</h3>
   
   <p>
    VSCodium is a great open-source code editor that supports Python linting. To
    set up linting in VSCodium:
   </p>

   <pre><code>pip install flake8</code></pre>
   
   <p>
    Configure VSCodium to use flake8 for linting to ensure code quality and
    adherence to PEP 8 standards.
   </p>

   <h3>Python - PIP</h3>
   
   <p>List installed pip modules (updated version):</p>
   
   <pre><code>python3 -m pip list</code></pre>
   
   <p>Update pip:</p>
   
   <pre><code>python3 -m pip install --user --upgrade pip</code></pre>

   <h3>Python - SSL</h3>
   
   <p>To connect using a self-signed certificate in Python:</p>
   
   <pre><code>
   import ssl
   context = ssl._create_unverified_context()
   </code></pre>
  
 </body>
</html>
