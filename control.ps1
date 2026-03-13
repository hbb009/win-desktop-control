param($action, $x, $y)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 核心改进：自动确保工作目录存在
$workspace = "$HOME\.openclaw\ClawWorkspace\"
if (!(Test-Path $workspace)) {
    New-Item -ItemType Directory -Force -Path $workspace
}

if ($action -eq "snapshot") {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
    $path = "$HOME\.openclaw\ClawWorkspace\last_screen.png"
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Output "Screenshot saved to $path"
}
if ($action -eq "move") {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
}
if ($action -eq "click") {
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
    $signature = '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int data, int extra);'
    $type = Add-Type -MemberDefinition $signature -Name "Win32Mouse" -Namespace "Win32" -PassThru
    $type::mouse_event(0x0002, 0, 0, 0, 0) # Left Down
    $type::mouse_event(0x0004, 0, 0, 0, 0) # Left Up
}