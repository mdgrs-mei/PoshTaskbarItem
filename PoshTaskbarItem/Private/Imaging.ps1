Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

function IsIcoConvertableFile($filePath)
{
    $supportedExtensions = @(
        ".png",
        ".bmp",
        ".tif",
        ".tiff"
        ".gif",
        ".jpg"
    )

    $ext = [System.IO.Path]::GetExtension($filePath)
    $supportedExtensions.Contains($ext)
}

function ConvertImageToIco($sourceImagePath, $icoPath)
{
    $sourceImage = [Drawing.Image]::FromFile($sourceImagePath)
    $icon = CreateIconFromImage $sourceImage

    $fileStream = [IO.File]::Create($icoPath)
    $icon.Save($fileStream)
    $fileStream.Close()
    $icon.Dispose()
}

# https://docs.microsoft.com/en-us/previous-versions/ms997538(v=msdn.10)?redirectedfrom=MSDN
function CreateIconFromImage($image)
{
    $memoryStream = New-Object System.IO.MemoryStream
    $writer = New-Object System.IO.BinaryWriter($memoryStream);

    # ICONDIR
    $writer.Write([Int16]0) # reserved
    $writer.Write([Int16]1) # resource type 1 for icons
    $writer.Write([Int16]1); # number of images

    # ICONDIRENTRY
    $w = $image.Width
    if ($w -ge 256)
    {
        $w = 0 # 0 means 256 pixel
    }
    $writer.Write([Byte]$w)
    $h = $image.Height;
    if ($h -ge 256)
    {
        $h = 0
    }
    $writer.Write([Byte]$h)
    $writer.Write([Byte]0) #Number of colors in image (0 if >=8bpp)
    $writer.Write([Byte]0) # Reserved ( must be 0)
    $writer.Write([Int16]0) # Color Planes
    $writer.Write([Int16]0) # Bits per pixel
    $imageSizePos = $memoryStream.Position

    $writer.Write([Int]0) # How many bytes in this resource?
    $imageStart = [Int]$memoryStream.Position + 4
    $writer.Write([Int]$imageStart) # Where in the file is this image?

    # Image data
    $image.Save($memoryStream, [System.Drawing.Imaging.ImageFormat]::Png)
    $imageSize = [Int]$memoryStream.Position - $imageStart
    $memoryStream.Seek($imageSizePos, [System.IO.SeekOrigin]::Begin) | Out-Null
    $writer.Write([Int]$imageSize)
    $memoryStream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null

    return New-Object System.Drawing.Icon($memoryStream);
}


# https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-deleteobject
Add-Type -MemberDefinition @"
[DllImport("gdi32.dll")]
public static extern bool DeleteObject(IntPtr hObject);
"@ -Namespace PoshTaskbarItem -Name Win32DeleteObject

# https://docs.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-extracticonexa
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

namespace PoshTaskbarItem {

public class IconExtractor
{
    [DllImport("Shell32.dll", CharSet = CharSet.Unicode)]
    private static extern uint ExtractIconEx(
        string lpszFile,
        int nIconIndex,
        IntPtr phiconLarge,
        out IntPtr phiconSmall,
        uint nIcons
    );

    public static IntPtr ExtractSmallIcon(string filePath, int iconIndex)
    {
        IntPtr smallIconHandle;
        uint extractedIconCount = ExtractIconEx(filePath, iconIndex, IntPtr.Zero, out smallIconHandle, 1);
        if (extractedIconCount == 1)
        {
            return smallIconHandle;
        }
        else
        {
            return IntPtr.Zero;
        }
    }
}

}
"@

function CreateBitmapSourceFromIconResource($filePath, $iconIndex)
{
    $hIcon = [PoshTaskbarItem.IconExtractor]::ExtractSmallIcon($filePath, $iconIndex)
    if ($hIcon -eq 0)
    {
        return $null
    }

    $icon = [System.Drawing.Icon]::FromHandle($hIcon)
    $bitmap = $icon.ToBitmap()
    $hBitmap = $bitmap.GetHbitmap()
    $bitmapSource = [System.Windows.Interop.Imaging]::CreateBitmapSourceFromHBitmap(
        $hBitmap,
        [System.IntPtr]::Zero,
        [System.Windows.Int32Rect]::Empty,
        [System.Windows.Media.Imaging.BitmapSizeOptions]::FromEmptyOptions())

    [PoshTaskbarItem.Win32DeleteObject]::DeleteObject($hBitmap) | Out-Null
    $bitmapSource
}

function GetImageSource($iconResourcePath, $iconResourceIndex)
{
    if (-not $iconResourcePath)
    {
        return
    }

    $iconApplications = @(Get-Command -Type Application $iconResourcePath)
    if ($iconApplications)
    {
        $iconResourceFullPath = $iconApplications[0].Source
        $iconResource = CreateBitmapSourceFromIconResource $iconResourceFullPath $iconResourceIndex
        if ($iconResource)
        {
            # exe, dll or ico file
            return $iconResource
        }
    }

    # other image files
    $pathInfo = Resolve-Path $iconResourcePath
    if ($pathInfo)
    {
        $iconResourceFullPath = $pathInfo.Path
        $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
        $bitmap.BeginInit()
        $bitmap.UriSource = New-Object System.Uri($iconResourceFullPath, [System.UriKind]::RelativeOrAbsolute)
        $bitmap.EndInit()
        return $bitmap
    }
}

function GetIconResourceFullPath($iconResourcePath)
{
    $iconResourceFullPath = $null
    if (IsIcoConvertableFile $iconResourcePath)
    {
        # Handle image files here as they have to be converted to .ico
        $pathInfo = Resolve-Path $iconResourcePath
        if ($pathInfo)
        {
            $iconResourceFullPath = $pathInfo.Path
            $icoPath = [System.IO.Path]::ChangeExtension($iconResourceFullPath, ".ico")
            if (Test-Path $icoPath)
            {
                # .ico file already exists
            }
            else
            {
                ConvertImageToIco $iconResourceFullPath $icoPath
            }
            $iconResourceFullPath = $icoPath
        }
    }
    else
    {
        # Support relative paths, full paths and files under $env:Path
        $iconApplications = @(Get-Command -Type Application $IconResourcePath)
        if ($iconApplications)
        {
            $iconResourceFullPath = $iconApplications[0].Source
        }
    }
    $iconResourceFullPath
}