namespace SOH.WebAPI.Controllers
{
    /// <summary>
    /// Picture bytes are stored without their MIME type, so it is derived from
    /// the magic bytes when serving — the same two formats ImageValidator
    /// accepts on the way in.
    /// </summary>
    internal static class ImageContentType
    {
        public static string For(byte[] bytes)
        {
            if (bytes.Length >= 4 &&
                bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47)
            {
                return "image/png";
            }

            if (bytes.Length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF)
            {
                return "image/jpeg";
            }

            return "application/octet-stream";
        }
    }
}
