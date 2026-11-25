# TextField

TextField is a labelled text input with a hint or an error next to it, for creating an account and signing in.

**Provide:** `label`, optional `type` (`email`, `password`, `text`), `value`/`defaultValue` + `onChange`, `hint` (shown while there is no error), `error` (replaces the hint), `autoComplete`, `minLength`/`maxLength`, `disabled`.

- Label `body-strong` above; field 56 high, padding 0 16, `radius-chip`, `surface`, text `body`, 2 px `ink-soft` border (5,15:1). Focus and error: 3 px `ink` border (`border-board`).
- Hint in `note`, `ink-soft`. Error in `note-strong`, `ink`, with the `alert` icon and `role="alert"`, linked by `aria-describedby` — the error is said in words and shown by icon and border, never by colour alone.
- Errors go next to their field, in the player's language:
  - Password hint: «Mínimo 15 caracteres; puede ser una frase» / «At least 15 characters; a phrase works too» (15 to 128).
  - Too short: «Es muy corta: usa 15 caracteres o más.» / «Too short: use 15 characters or more.»
  - Too common: «Es demasiado común; prueba una frase tuya.» / «That one is too common; try a phrase of your own.»
  - Email taken: «Ese correo ya tiene una cuenta.» / «That email already has an account.»
  - Name taken: «Ese nombre ya lo usa otra persona.» / «Someone else is already using that name.»
- Sign-in uses one generic message for wrong credentials, under the password field: «El correo o la contraseña no coinciden.» / «The email or password doesn't match.» Never say which one failed.
