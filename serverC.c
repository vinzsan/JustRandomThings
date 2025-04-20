#ifdef __WIN32

#include <winsock2.h>
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(){
  struct WSAData wsa;
  SOCKET sockfd,client_fd;
  struct sockaddr_in server_addr,client_addr;
  int addr_len = sizeof(client_addr);
  char *buffer = malloc(1024);
  char *msg = "Hello world";

  WSAStartup(MAKEWORD(2, 2), &wsa);

  sockfd = socket(AF_INET,SOCK_STREAM,0);

  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(80);
  server_addr.sin_addr.s_addr = INADDR_ANY;
  memset(&server_addr.sin_zero,0,sizeof(server_addr.sin_zero));

  bind(sockfd,(struct sockaddr *)&server_addr,sizeof(server_addr));

  listen(sockfd,1);

  client_fd = accept(sockfd,(struct sockaddr *)&client_addr,&addr_len);

  send(client_fd,msg,strlen(msg),0);
  int len = recv(client_fd,buffer,1024,0);

  write(1,buffer,len);
  free(buffer);

  closesocket(sockfd);
  closesocket(client_fd);
  WSACleanup();
  return 0;
}

#endif

#ifdef __linux

#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>

void handler(int signal){
  printf("Signal %d Recieved,Exiting server\n",signal);
  fflush(stdout);
  exit(0);
}

int main(){
  struct sigaction sig;
  sig.sa_handler = handler;
  sig.sa_flags = SA_RESTART;
  sigemptyset(&sig.sa_mask);
  sigaction(SIGINT,&sig,NULL);
  sigaction(SIGSEGV,&sig,NULL);

  struct sockaddr_in server_addr,client_addr;
  socklen_t addr_len = sizeof(client_addr);
  char *buffer = malloc(1024);
  char *msg = "Hello from Server\n";

  int sockfd = socket(AF_INET,SOCK_STREAM,0);
  
  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(80);
  server_addr.sin_addr.s_addr = INADDR_ANY;
  memset(&server_addr.sin_zero,0,sizeof(server_addr.sin_zero));

  if(bind(sockfd,(struct sockaddr *)&server_addr,sizeof(server_addr)) < 0){
    perror("Error Bind");
    free(buffer);
    close(sockfd);
    return 1;
  }

  listen(sockfd,1);

  int client_fd = accept(sockfd,(struct sockaddr *)&client_addr,&addr_len);

  send(client_fd,msg,strlen(msg),0);
  int len = recv(client_fd,buffer,1024,0);
  write(1,buffer,len);
  free(buffer);
  close(sockfd);
  close(client_fd);
  return 0;
}

#endif
