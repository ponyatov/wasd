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

void serve(string argv0, string ip, ushort port) {
    auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
    writefln("%s @ http://%s:%d (%s)", argv0, ip, port, listener.hostName);
    listener.bind(new InternetAddress(ip, port));
    listener.listen(1);
    // while (true) {
    // recv
    auto client = listener.accept();
    writefln("%s %s", client.remoteAddress, client.hostName);
    char[1024] buffer;
    auto got = client.receive(buffer);
    foreach (i; http(buffer[0 .. got].idup())) {
        foreach (j; i) {
            writeln(j);
        }
    }
    // resp
    client.send("HTTP/1.1 200 OK\n"c);
    client.send("Content-Type: text/plain; charset=utf-8\n"c);
    client.send("\n"c);
    client.send(buffer[0 .. got]);
    client.close();
    // }
}

/// @}
