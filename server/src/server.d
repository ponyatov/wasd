/// @file
/// @brief tiny HTTP server for SPA applications

module server;

/// @defgroup server server
/// @brief tiny HTTP server for SPA applications
/// @{

import config;

import std.stdio;
import std.range;
import std.socket;

/// @brief program entry point
/// @param[in] args command line arguments
void main(string[] args) {
    arg(0, args[0]);
    foreach (argc, argv; args[1 .. $].enumerate(1)) {
        arg(argc, argv);
    }
    serve(args[0], config.IP, config.PORT);
}

/// @brief print single command line argument
/// @param[in] argc index
/// @param[in] argv value
void arg(int argc, string argv) {
    writefln("argv[%d] = <%s>", argc, argv);
}

import pegged.grammar;

mixin(grammar(`
    http:
        head     < 'GET' [/a-z\.]+ :"HTTP/1.1"
`));

const index_html = cast(immutable ubyte[]) import("index.html");
const css_css = cast(immutable ubyte[]) import("css.css");
const logo_png = cast(immutable ubyte[]) import("logo.png");

const ok = "HTTP/1.1 200 OK\n"c;
const plain = "Content-Type: text/plain; charset=utf-8\n"c;
const png = "Content-Type: image/png\n"c;

void serve(string argv0, string ip, ushort port) {
    auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
    writefln("%s @ http://%s:%d (%s)", argv0, ip, port, listener.hostName);
    listener.bind(new InternetAddress(ip, port));
    listener.listen(1);
    while (true) {
        // recv
        auto client = listener.accept();
        writef("%s %s\t", client.remoteAddress, client.hostName);
        char[1024] buffer;
        auto got = client.receive(buffer);
        writeln(buffer[0..got]);
        // resp
        auto req = http(buffer[0 .. got].idup())[0].matches;
        auto method = req[0];
        auto url = req[1];
        writeln(method, ' ', url);
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
