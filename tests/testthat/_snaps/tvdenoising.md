# tvdenoising handles incorrect input properly

    Code
      tvdenoising(y, lambda)
    Condition
      Error in `tvdenoising()`:
      ! is.numeric(lambda) & (length(lambda) == 1) is not TRUE

---

    Code
      tvdenoising(y, 1, weights)
    Condition
      Error in `tvdenoising()`:
      ! length(weights) == length(y) is not TRUE

