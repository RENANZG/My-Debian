import socket

s = socket.socket()

for port in range(90):
    try:
        print "[+] Connecting 127.0.0.1: " + str(port)
        s.connect(("127.0.0.1", port))
        s.send("Testing. . Testing")
        data = s.recv(2048)
        if data:
            print "[+] Port " + str(port) + " open: " + data
        s.close()
    except:
        pass
