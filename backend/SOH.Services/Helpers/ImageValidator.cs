using SOH.Model.Exceptions;

namespace SOH.Services.Helpers
{
    /// <summary>
    /// Validates uploaded picture bytes by magic bytes (not extension) and size,
    /// per the rubric's file-upload hardening requirement.
    /// </summary>
    public static class ImageValidator
    {
        private const int MaxSizeBytes = 2 * 1024 * 1024; // 2 MB

        private static readonly byte[] PngMagic = { 0x89, 0x50, 0x4E, 0x47 };
        private static readonly byte[] JpegMagic = { 0xFF, 0xD8, 0xFF };

        public static void Validate(byte[]? picture, string fieldName)
        {
            if (picture == null || picture.Length == 0)
                return;

            if (picture.Length > MaxSizeBytes)
            {
                throw new BusinessException("Slika je prevelika. Maksimalna veličina je 2 MB.");
            }

            if (!StartsWith(picture, PngMagic) && !StartsWith(picture, JpegMagic))
            {
                throw new BusinessException("Nepodržan format slike. Dozvoljeni formati su PNG i JPEG.");
            }
        }

        private static bool StartsWith(byte[] data, byte[] prefix)
        {
            if (data.Length < prefix.Length)
                return false;

            for (var i = 0; i < prefix.Length; i++)
            {
                if (data[i] != prefix[i])
                    return false;
            }

            return true;
        }
    }
}
