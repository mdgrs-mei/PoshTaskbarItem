Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

namespace PoshTaskbarItem {

public class FlashWindow
{
    [StructLayout(LayoutKind.Sequential)]
    public struct FLASHWINFO
    {
        public UInt32 cbSize;
        public IntPtr hwnd;
        public UInt32 dwFlags;
        public UInt32 uCount;
        public UInt32 dwTimeout;
    }

    // Flash both the window caption and taskbar button.
    // This is equivalent to setting the FLASHW_CAPTION | FLASHW_TRAY flags.
    const UInt32 FLASHW_ALL = 3;

    // Flash continuously until the window comes to the foreground.
    const UInt32 FLASHW_TIMERNOFG = 12;

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool FlashWindowEx(ref FLASHWINFO pwfi);

    public static bool Flash(IntPtr hWnd, UInt32 rateInMillisecond, UInt32 count)
    {
        FLASHWINFO flashInfo = new FLASHWINFO();

        flashInfo.cbSize = Convert.ToUInt32(Marshal.SizeOf(flashInfo));
        flashInfo.hwnd = hWnd;
        flashInfo.dwFlags = FLASHW_ALL | FLASHW_TIMERNOFG;
        flashInfo.uCount = count;
        flashInfo.dwTimeout = rateInMillisecond;

        return FlashWindowEx(ref flashInfo);
    }
}

}
'@

Add-Type -MemberDefinition @'
[DllImport("user32.dll")] public static extern uint GetDpiForWindow(IntPtr hWnd);
'@ -Namespace PoshTaskbarItem -Name Win32GetDpiForWindow

Add-Type -MemberDefinition @'
[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'@ -Namespace PoshTaskbarItem -Name Win32ShowWindow

function FlashWindow($mainWindowHandle, $rateInMillisecond, $count)
{
    [PoshTaskbarItem.FlashWindow]::Flash($mainWindowHandle, $rateInMillisecond, $count) | Out-Null
}

function GetDpiForWindow($windowHandle)
{
    [PoshTaskbarItem.Win32GetDpiForWindow]::GetDpiForWindow($windowHandle)
}

function ShowWindow($windowHandle)
{
    $SW_SHOWDEFAULT = 10
    [PoshTaskbarItem.Win32ShowWindow]::ShowWindow($windowHandle, $SW_SHOWDEFAULT) | Out-Null
}
