namespace SOH.Model.Responses
{
    public class ProductResponse
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int ProductCategoryId { get; set; }
        public string ProductCategoryName { get; set; } = string.Empty;
        /// <summary>
        /// Full image bytes. Populated on the details endpoint only; list rows
        /// leave this null and set <see cref="HasPicture"/> instead. Fetch the
        /// image from <c>GET /Product/{id}/picture</c>.
        /// </summary>
        public byte[]? Picture { get; set; }

        /// <summary>True when a picture exists, whether or not it is included.</summary>
        public bool HasPicture { get; set; }
    }
}
