import { validator } from "./udemy";

describe("udemy id validator", () => {
  it("accepts valid id", () => {
    const id = "felipe-bernardes-5";

    expect(validator(id)).toEqual({
      valid: true,
      value: "https://www.udemy.com/user/felipe-bernardes-5",
      originalValue: id
    });
  });

  it("accepts valid url", () => {
    const url = "https://www.udemy.com/user/felipe-bernardes-5/";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://www.udemy.com/user/felipe-bernardes-5",
      originalValue: url
    });
  });

  it("accepts valid url without www", () => {
    const url = "https://udemy.com/user/felipe-bernardes-5/";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://www.udemy.com/user/felipe-bernardes-5",
      originalValue: url
    });
  });

  it("accepts valid url with query params", () => {
    const url =
      "https://www.udemy.com/user/felipe-bernardes-5?utm_source=google.com";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://www.udemy.com/user/felipe-bernardes-5",
      originalValue: url
    });
  });

  it("rejects invalid id", () => {
    const id = "#%ˆ&&*&ˆhhad";

    expect(validator(id)).toEqual({
      valid: false,
      value: undefined,
      originalValue: id
    });
  });

  it("rejects invalid url", () => {
    const url = "https://github.com/felipe-bernardes-5/";

    expect(validator(url)).toEqual({
      valid: false,
      value: undefined,
      originalValue: url
    });
  });
});
