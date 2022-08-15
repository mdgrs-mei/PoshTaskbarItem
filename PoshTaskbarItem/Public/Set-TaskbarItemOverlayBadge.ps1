<#
.SYNOPSIS
Sets the text badge of a TaskbarItem.

.DESCRIPTION
Sets the text badge displayed over a TaskbarItem icon in the taskbar. This function and Set-TaskbarItemOverlayIcon sets the same overlay property of a TaskbarItem.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER Text
The text displayed in the frame.

.PARAMETER BadgeSize
The size of the badge. The value is a pixel count at 96 dpi. The size relative to the application icon size will be kept the same regardless of the display scale setting.

.PARAMETER FontSize
Font size of the text. The value is a pixel count at 96 dpi.

.PARAMETER FrameWidth
The width of the badge frame. The value is a pixel count at 96 dpi.

.PARAMETER BackgroundColor
The background color of the badge. You can use one of the WPF color names:
https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.colors

.PARAMETER ForegroundColor
The color of the font and the frame. You can use one of the WPF color names:
https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.colors

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemOverlayBadge $taskbarItem -Text "3" -BadgeSize 14 -BackgroundColor MediumPurple

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.windows.shell.taskbariteminfo.overlay

#>
function Set-TaskbarItemOverlayBadge
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Text,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Double]$BadgeSize = 16,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Double]$FontSize = $BadgeSize * 0.7,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Double]$FrameWidth = $BadgeSize * 0.09,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("AliceBlue","AntiqueWhite","Aqua","Aquamarine","Azure","Beige","Bisque","Black","BlanchedAlmond","Blue",
            "BlueViolet","Brown","BurlyWood","CadetBlue","Chartreuse","Chocolate","Coral","CornflowerBlue","Cornsilk","Crimson",
            "Cyan","DarkBlue","DarkCyan","DarkGoldenrod","DarkGray","DarkGreen","DarkKhaki","DarkMagenta","DarkOliveGreen",
            "DarkOrange","DarkOrchid","DarkRed","DarkSalmon","DarkSeaGreen","DarkSlateBlue","DarkSlateGray","DarkTurquoise",
            "DarkViolet","DeepPink","DeepSkyBlue","DimGray","DodgerBlue","Firebrick","FloralWhite","ForestGreen","Fuchsia",
            "Gainsboro","GhostWhite","Gold","Goldenrod","Gray","Green","GreenYellow","Honeydew","HotPink","IndianRed","Indigo",
            "Ivory","Khaki","Lavender","LavenderBlush","LawnGreen","LemonChiffon","LightBlue","LightCoral","LightCyan","LightGoldenrodYellow",
            "LightGray","LightGreen","LightPink","LightSalmon","LightSeaGreen","LightSkyBlue","LightSlateGray","LightSteelBlue","LightYellow",
            "Lime","LimeGreen","Linen","Magenta","Maroon","MediumAquamarine","MediumBlue","MediumOrchid","MediumPurple","MediumSeaGreen","MediumSlateBlue",
            "MediumSpringGreen","MediumTurquoise","MediumVioletRed","MidnightBlue","MintCream","MistyRose","Moccasin","NavajoWhite","Navy","OldLace",
            "Olive","OliveDrab","Orange","OrangeRed","Orchid","PaleGoldenrod","PaleGreen","PaleTurquoise","PaleVioletRed","PapayaWhip","PeachPuff","Peru",
            "Pink","Plum","PowderBlue","Purple","Red","RosyBrown","RoyalBlue","SaddleBrown","Salmon","SandyBrown","SeaGreen","SeaShell","Sienna","Silver",
            "SkyBlue","SlateBlue","SlateGray","Snow","SpringGreen","SteelBlue","Tan","Teal","Thistle","Tomato","Transparent","Turquoise","Violet","Wheat",
            "White","WhiteSmoke","Yellow","YellowGreen")]
        [String]$BackgroundColor = "DeepPink",

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("AliceBlue","AntiqueWhite","Aqua","Aquamarine","Azure","Beige","Bisque","Black","BlanchedAlmond","Blue",
        "BlueViolet","Brown","BurlyWood","CadetBlue","Chartreuse","Chocolate","Coral","CornflowerBlue","Cornsilk","Crimson",
        "Cyan","DarkBlue","DarkCyan","DarkGoldenrod","DarkGray","DarkGreen","DarkKhaki","DarkMagenta","DarkOliveGreen",
        "DarkOrange","DarkOrchid","DarkRed","DarkSalmon","DarkSeaGreen","DarkSlateBlue","DarkSlateGray","DarkTurquoise",
        "DarkViolet","DeepPink","DeepSkyBlue","DimGray","DodgerBlue","Firebrick","FloralWhite","ForestGreen","Fuchsia",
        "Gainsboro","GhostWhite","Gold","Goldenrod","Gray","Green","GreenYellow","Honeydew","HotPink","IndianRed","Indigo",
        "Ivory","Khaki","Lavender","LavenderBlush","LawnGreen","LemonChiffon","LightBlue","LightCoral","LightCyan","LightGoldenrodYellow",
        "LightGray","LightGreen","LightPink","LightSalmon","LightSeaGreen","LightSkyBlue","LightSlateGray","LightSteelBlue","LightYellow",
        "Lime","LimeGreen","Linen","Magenta","Maroon","MediumAquamarine","MediumBlue","MediumOrchid","MediumPurple","MediumSeaGreen","MediumSlateBlue",
        "MediumSpringGreen","MediumTurquoise","MediumVioletRed","MidnightBlue","MintCream","MistyRose","Moccasin","NavajoWhite","Navy","OldLace",
        "Olive","OliveDrab","Orange","OrangeRed","Orchid","PaleGoldenrod","PaleGreen","PaleTurquoise","PaleVioletRed","PapayaWhip","PeachPuff","Peru",
        "Pink","Plum","PowderBlue","Purple","Red","RosyBrown","RoyalBlue","SaddleBrown","Salmon","SandyBrown","SeaGreen","SeaShell","Sienna","Silver",
        "SkyBlue","SlateBlue","SlateGray","Snow","SpringGreen","SteelBlue","Tan","Teal","Thistle","Tomato","Transparent","Turquoise","Violet","Wheat",
        "White","WhiteSmoke","Yellow","YellowGreen")]
        [String]$ForegroundColor = "White"
    )

    process
    {
        if (-not $InputObject.MainWindowHandle)
        {
            # This taskbar item has not been showed yet.
            # Call the function again after the window is shown to get its Window DPI.
            $InputObject.OnLoadedForOverlayBadge = {
                Set-TaskbarItemOverlayBadge -InputObject $InputObject -Text $Text -BadgeSize $BadgeSize -FontSize $FontSize -FrameWidth $FrameWidth -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor
            }.GetNewClosure()
            return
        }

        $wpfDpi = 96
        $dpiScale = 1.0
        $windowDpi = GetDpiForWindow $InputObject.MainWindowHandle
        if ($windowDpi -ne 0)
        {
            $dpiScale = $windowDpi / $wpfDpi
        }

        $parameters = [PSCustomObject]@{
            Text = $Text;
            BadgeSize = $BadgeSize * $dpiScale;
            FontSize = $FontSize * $dpiScale;
            FrameWidth = $FrameWidth * $dpiScale;
            Radius = $BadgeSize * 0.14;
            BackgroundColor = $BackgroundColor;
            ForegroundColor = $ForegroundColor
        }

        $bitmap = New-Object System.Windows.Media.Imaging.RenderTargetBitmap $parameters.BadgeSize, $parameters.BadgeSize, $wpfDpi, $wpfDpi, ([System.Windows.Media.PixelFormats]::Default)
        $rect = New-Object System.Windows.Rect 0, 0, $parameters.BadgeSize, $parameters.BadgeSize
        $control = New-Object System.Windows.Controls.ContentControl
        $control.ContentTemplate = $InputObject.Window.Resources["OverlayBadge"]
        $control.Content = $parameters
        $control.Arrange($rect)
        $bitmap.Render($control)
        $InputObject.Window.TaskbarItemInfo.Overlay = $bitmap
    }
}
