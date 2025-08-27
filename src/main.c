#include <windows.h>
#include <winuser.h>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

// windows entrypoint, called by windows to start up our code
// takes an instance of the program, the cmdline arguments as a string, and
// whether the program starts minimized or maximized
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                    PWSTR lpCmdLine, int nCmdShow) {
  const wchar_t TICTACS_WINDOW[] = L"Tictacs Window Class for Noodles";
  WNDCLASSW wc = {};

  wc.lpfnWndProc = WindowProc;
  // instance handle, easy to get from the wWinMain
  wc.hInstance = hInstance;
  // identifies the class
  wc.lpszClassName = TICTACS_WINDOW;
  // wc.HIcon;

  // registers class for use in the windows proc
  RegisterClassW(&wc);

  HWND hwnd = CreateWindowExW(0, TICTACS_WINDOW, "EPILEPSYWARNING",
                              WS_OVERLAPPEDWINDOW | WS_VISIBLE, CW_USEDEFAULT,
                              CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL,
                              NULL, hInstance, NULL);

  if (hwnd == NULL) {
    return 0;
  }

  ShowWindow(hwnd, nCmdShow);

  MSG msg = {};
  while (GetMessage(&msg, NULL, 0, 0) > 0) {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }
}

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam,
                            LPARAM lParam) {
  LRESULT Result = 0;
  switch (uMsg) {
  case WM_PAINT: {
    PAINTSTRUCT ps;

    // Device context nonsense
    HDC hdc = BeginPaint(hwnd, &ps);
    int X = ps.rcPaint.left;
    int Y = ps.rcPaint.top;
    int Height = ps.rcPaint.bottom - ps.rcPaint.top;
    int Width = ps.rcPaint.right - ps.rcPaint.left;
    static DWORD Operation = BLACKNESS;

    PatBlt(hdc, X, Y, Width, Height, Operation);
    if (Operation == BLACKNESS) {
      Operation = WHITENESS;
    } else {
      Operation = BLACKNESS;
    }
    // FillRect(hdc, &ps.rcPaint, (HBRUSH)(COLOR_WINDOW + 1));
    EndPaint(hwnd, &ps);
  } break;
  case WM_CLOSE: {
    if (MessageBoxW(hwnd, L"NO DONT DO IT", L"I'LL DIE", MB_OKCANCEL) == IDOK) {
      DestroyWindow(hwnd);
    }
  } break;
  case WM_SIZE: {

  } break;

  case WM_DESTROY: {
    PostQuitMessage(0);
  } break;
  default: {
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
  }
  }
  return (Result);
}
