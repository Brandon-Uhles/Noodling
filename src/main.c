#include <stdio.h>

#ifdef _WIN32
#include <windows.h>
#endif

int main(void) {
  printf("Hello from C!\n");

#ifdef _WIN32
  MessageBoxA(NULL, "Hello from Windows!", "Cross-Platform Test", MB_OK);
#else
  printf("Running on Linux/Unix!");
#endif

  return 0;
}
