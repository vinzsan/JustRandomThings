#ifdef __linux

#define _POSIX_C_SOURCE 200809L
// For Sigaction 64 bit
#include <stdio.h>
#include <unistd.h> 
#include <stdlib.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <signal.h>
#include <string.h>

#endif

#ifdef _WIN32

#include <winsock2.h>
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <ws2tcpip.h>

#endif

#define MAX_HANDLER 5
#define MAX_USER 1

#define STDOUT 1

#define PORT 80 // default
#define IP_ADDR INADDR_ANY

void handler(int sig){
    printf("Signal action %d received\nExiting", sig);
    fflush(stdout);
    exit(0);
}

int main() {
    char *buffer = malloc(1024);
    char *msg = "\033[1;31mFrom Local Server\033[0m\n";

#ifdef _WIN32
    WSADATA wsa;
    SOCKET server, client;
    struct sockaddr_in serverAddr, clientAddr;
    int client_len = sizeof(clientAddr);

    WSAStartup(MAKEWORD(2, 2), &wsa);

    server = socket(AF_INET, SOCK_STREAM, 0);
    if (server == INVALID_SOCKET) {
        perror("Error");
        WSACleanup();
        return 1;
    }

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(PORT);
    serverAddr.sin_addr.s_addr = IP_ADDR;

    if (bind(server, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR) {
        perror("Bind failed");
        closesocket(server);
        WSACleanup();
        return 1;
    }

    listen(server, MAX_USER);

    client = accept(server, (struct sockaddr *)&clientAddr, &client_len);

    send(client, msg, (int)strlen(msg), 0);
    recv(client, buffer, 1024, 0);

    DWORD bytesWritten;
    WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), buffer, strlen(buffer), &bytesWritten, NULL);

    closesocket(server);
    closesocket(client);
    WSACleanup();
    free(buffer);
    return 0;

#endif

#ifdef __linux
    struct sockaddr_in server_addr, client_addr;
    struct sigaction sa;
    socklen_t addr_len = sizeof(client_addr);

    sa.sa_flags = SA_RESTART;
    sa.sa_handler = handler;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGINT, &sa, NULL);

    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("Error Making Socket");
        return 1;
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = IP_ADDR;
    memset(&server_addr.sin_zero, 0, sizeof(server_addr.sin_zero));

    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Error when bind");
        return 1;
    }

    listen(sockfd, MAX_USER);

    int client_fd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);

    send(client_fd, msg, strlen(msg), 0);
    recv(client_fd, buffer, 1024, 0);
    write(STDOUT_FILENO, buffer, 1024);
    close(sockfd);
    close(client_fd);
    free(buffer);
    return 0;
#endif
}
