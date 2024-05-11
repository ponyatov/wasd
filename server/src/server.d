/// @file
/// @brief tiny HTTP server for SPA applications

module server;

/// @defgroup server server
/// @brief tiny HTTP server for SPA applications
/// @{

import config;

import std.stdio;
import std.range;
import std.string;
import std.socket;

/// @brief program entry point
/// @param[in] args command line arguments
void main(string[] args) {
    arg(0, args[0]);
    foreach (argc, argv; args[1 .. $].enumerate(1)) {
        arg(argc, argv);
    }
    serve(args[0]);
}

/// @brief print single command line argument
/// @param[in] argc index
/// @param[in] argv value
void arg(int argc, string argv) {
    writefln("argv[%d] = <%s>", argc, argv);
}

/// @name static files compiled into binary
/// @{
const index_html = cast(immutable ubyte[]) import("index.html");
const css_css = cast(immutable ubyte[]) import("css.css");
const logo_png = cast(immutable ubyte[]) import("logo.png");
/// @}

/// @name MIME types
/// @{
const ok = "HTTP/1.1 200 OK\n"c;
const plain = "Content-Type: text/plain; charset=utf-8\n"c;
const png = "Content-Type: image/png\n"c;
/// @}

/// @name network i/o

/// @brief get a parse HTTP request (most dumb way: only first header line)
/// @param[in] acrtive client socket
string[] http_request(Socket client) {
    writef("%s %s\t", client.remoteAddress, client.hostName);
    char[1024] buffer;
    auto got = client.receive(buffer);
    return buffer[0 .. got].idup().splitLines()[0].split(' ');
}

/// @brief serve HTTP request (single thread, no socket.select)
/// @param[in] argv0 server binary/executeable file name (for log)
/// @param[in] ip @ref config.IP
/// @param[in] port @ref config.PORT
void serve(string argv0, string ip = config.IP, ushort port = config.PORT) {
    auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
    writefln("%s @ http://%s:%d (%s)", argv0, ip, port, listener.hostName);
    listener.bind(new InternetAddress(ip, port));
    listener.listen(1);
    while (true) {
        // http_request
        auto client = listener.accept();
        auto req = http_request(client);
        auto method = req[0];
        auto url = req[1];
        writeln(method, ' ', url);
        // resp
        switch (method) {
        case "GET":
            switch (url) {
            case "/":
                client.send(ok ~ plain ~ '\n');
                client.send(index_html);
                break;
            case "/favicon.ico":
                client.send(ok ~ png ~ '\n');
                client.send(logo_png);
                break;
            default:
                break;
            }
            break;
        default:
            break;
        }

        client.close();
    }
}

/// @}
