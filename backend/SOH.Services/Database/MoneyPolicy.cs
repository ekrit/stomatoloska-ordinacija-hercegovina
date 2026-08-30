namespace SOH.Services.Database
{
    /// <summary>
    /// The single definition of what money means in this system.
    /// <para>
    /// The clinic prices everything in convertible marks: the service catalog,
    /// the product catalog, booking and orders all display KM. PayPal, however,
    /// does not settle in BAM, so a card payment has to be presented in another
    /// currency. Previously the same decimal was simply handed to PayPal with
    /// <c>currency_code = EUR</c>, which did not relabel the price — it charged
    /// a different amount of money: 50 KM became 50 EUR, nearly twice the bill.
    /// </para>
    /// <para>
    /// The rule here is explicit and stable: BAM is pegged to the euro by
    /// currency board at the official rate 1 EUR = 1.95583 BAM, so the
    /// conversion is exact arithmetic rather than a floating market rate that
    /// would need a feed. The converted amount is what PayPal charges, and both
    /// the business amount and the charged amount are stored on the payment.
    /// </para>
    /// </summary>
    public static class MoneyPolicy
    {
        /// <summary>Currency every price in the system is expressed in.</summary>
        public const string BusinessCurrency = "BAM";

        /// <summary>Currency card payments are settled in.</summary>
        public const string ProviderCurrency = "EUR";

        /// <summary>
        /// Official fixed peg of the convertible mark to the euro.
        /// </summary>
        public const decimal BamPerEur = 1.95583m;

        /// <summary>
        /// Converts a KM amount to the euro amount to charge, rounded to two
        /// decimals away from zero (a half-fening never rounds in the payer's
        /// favour twice for the same bill).
        /// </summary>
        public static decimal ToProviderCurrency(decimal amountInBam)
        {
            return decimal.Round(amountInBam / BamPerEur, 2, MidpointRounding.AwayFromZero);
        }
    }
}
