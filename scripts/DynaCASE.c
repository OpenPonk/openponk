#include <windows.h>

int main(int argc, char **argv) {
	WinExec("vms\\win\\Pharo.exe dynacase.image", SW_SHOWNORMAL);
	return 0;
}
