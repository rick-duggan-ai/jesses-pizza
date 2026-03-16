using System;

namespace JessesPizza.Core.Models
{
    [Flags]
    public enum GroupType
    {
        Single,
        Multiple,
        MinMax
    }

    [Flags]
    public enum TransactionState
    {
        Validated,
        Authorized,
        InKitchen,
        OutForDelivery,
        Delivered,
        Cancelled,
        Declined,
        Failed
    }
    [Flags]
    public enum TransactionStateV1_1
    {
        Validated,
        Authorized,
        InKitchen,
        OutForDelivery,
        Delivered,
        Cancelled,
        Declined,
        Failed
    }
}
