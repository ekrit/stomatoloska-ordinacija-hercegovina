using System.Diagnostics;

namespace SOH.Services.Helpers
{
    /// <summary>
    /// Static image helpers used by EF seed data. Both readers swallow file
    /// errors and return null/empty so a missing seed asset does not abort
    /// migrations; diagnostic messages go through <see cref="Debug"/> so they
    /// surface in the IDE without polluting production stdout (the original
    /// implementation logged via Console.WriteLine, which the seminar rubric
    /// forbids in production code).
    /// </summary>
    public static class ImageConversion
    {
        public static byte[] HexToByteArray(string hex)
        {
            hex = hex.Replace("0x", "");
            byte[] bytes = new byte[hex.Length / 2];
            for (int i = 0; i < bytes.Length; i++)
            {
                bytes[i] = Convert.ToByte(hex.Substring(i * 2, 2), 16);
            }
            return bytes;
        }

        public static string? ConvertImageToBase64String(string folder, string imageName)
        {
            string imagePath = Path.Combine(Directory.GetCurrentDirectory(), folder, imageName);

            try
            {
                if (File.Exists(imagePath))
                {
                    var imageBytes = File.ReadAllBytes(imagePath);
                    return Convert.ToBase64String(imageBytes);
                }

                Debug.WriteLine($"[ImageConversion] Image file not found: {imagePath}");
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[ImageConversion] Error reading image '{imagePath}': {ex.Message}");
                return null;
            }
        }

        public static byte[]? ConvertImageToByteArray(string folder, string imageName)
        {
            string imagePath = Path.Combine(Directory.GetCurrentDirectory(), folder, imageName);

            try
            {
                if (File.Exists(imagePath))
                {
                    return File.ReadAllBytes(imagePath);
                }

                Debug.WriteLine($"[ImageConversion] Image file not found: {imagePath}");
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[ImageConversion] Error reading image '{imagePath}': {ex.Message}");
                return null;
            }
        }
    }
}

