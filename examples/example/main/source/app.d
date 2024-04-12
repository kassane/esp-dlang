pragma(printf)
extern(C)
int printf(scope const char* fmt, scope const ...);

extern(C)
void app_main()
{
    printf("CPU = %s\n", __traits(targetCPU).ptr);
    printf("Hello from dlang!\n");
}
