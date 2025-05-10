#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <termios.h>
#include <sys/select.h>

#define PORT 8080
#define MAX_BUFFER_SIZE 1024

typedef struct sockaddr_in sockaddr_in;
typedef struct termios termios;

void set_raw_mode(termios *old){
    termios new;
    tcgetattr(STDIN_FILENO, old);
    new = *old;
    new.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &new);
}

void restore_mode(termios *old){
    tcsetattr(STDIN_FILENO, TCSANOW, old);
}

int main(){
    signal(SIGPIPE, SIG_IGN);
    sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    termios old;
    set_raw_mode(&old);

    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if(sockfd < 0){
        perror("socket");
        return EXIT_FAILURE;
    }

    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));

    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);  // Ganti ke 8080
    server_addr.sin_addr.s_addr = INADDR_ANY;
    memset(server_addr.sin_zero, 0, sizeof(server_addr.sin_zero));

    if(bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0){
        perror("bind");
        close(sockfd);
        return EXIT_FAILURE;
    }

    if(listen(sockfd, 5) < 0){
        perror("listen");
        close(sockfd);
        return EXIT_FAILURE;
    }

    printf("[INFO] Listening on port %d\n", PORT);
    printf("Press 'q' to quit...\n");

    fd_set read_fds;
    int maxfd = sockfd > STDIN_FILENO ? sockfd : STDIN_FILENO;
    char ch;
    volatile int quit = 0;

    while (!quit) {
        FD_ZERO(&read_fds);
        FD_SET(STDIN_FILENO, &read_fds);
        FD_SET(sockfd, &read_fds);

        if(select(maxfd + 1, &read_fds, NULL, NULL, NULL) < 0){
            perror("select");
            break;
        }

        if(FD_ISSET(STDIN_FILENO, &read_fds)){
            read(STDIN_FILENO, &ch, 1);
            if(ch == 'q'){
                printf("\n[INFO] Quitting...\n");
                quit = 1;
            }
        }

        if(FD_ISSET(sockfd, &read_fds)){
            int client_sock = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
            if(client_sock < 0){
                perror("accept");
                continue;
            }

            char *buffer = calloc(1, MAX_BUFFER_SIZE);
            if(!buffer){
                perror("calloc");
                close(client_sock);
                continue;
            }

            ssize_t length = recv(client_sock, buffer, MAX_BUFFER_SIZE - 1, 0);
            if(length > 0){
                printf("[INFO] Received request:\n%.*s\n", (int)length, buffer);
                const char *response = "HTTP/1.1 200 OK\r\nContent-type: text/html\r\nContent-Length: 1024\r\n\r\n<h1>Hello, World!</h1>";
                send(client_sock, response, strlen(response), 0);
            }

            free(buffer);
            close(client_sock);
            printf("[INFO] Connection closed\n");
            sleep(1);
        }
    }

    close(sockfd);
    restore_mode(&old);
    return 0;
}
