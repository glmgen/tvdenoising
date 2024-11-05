# tvdenoising handles various errors

    Code
      tvdenoising(letters[1:10], 1)
    Condition
      Error in `tvdenoising()`:
      ! `y` must be numeric.

---

    Code
      tvdenoising(y, "not a number")
    Condition
      Error in `tvdenoising()`:
      ! `lambda` must be numeric.

---

    Code
      tvdenoising(y, c(3, 4))
    Condition
      Error in `tvdenoising()`:
      ! `lambda` must be a scalar.

---

    Code
      tvdenoising(y, -1)
    Condition
      Error in `tvdenoising()`:
      ! `lambda` must be non-negative.

---

    Code
      tvdenoising(y, 1, rep("a", length(y)))
    Condition
      Error in `tvdenoising()`:
      ! `weights` must be numeric or NULL.

---

    Code
      tvdenoising(y, 1, weights)
    Condition
      Error in `tvdenoising()`:
      ! `weights` must be the same size as `y`.

---

    Code
      tvdenoising(y, 1, weights)
    Condition
      Error in `tvdenoising()`:
      ! `weights` must be non-negative.

