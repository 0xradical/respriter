import { validator } from "./github";

describe("github id validator", () => {
  it("accepts valid id", () => {
    const id = "thiagobrandam";

    expect(validator(id)).toEqual({
      valid: true,
      value: "https://github.com/thiagobrandam",
      originalValue: id
    });
  });

  it("accepts valid url", () => {
    const url = "https://github.com/thiagobrandam/";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://github.com/thiagobrandam",
      originalValue: url
    });
  });

  it("accepts valid url with www", () => {
    const url = "https://www.github.com/thiagobrandam/";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://github.com/thiagobrandam",
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
    const url = "https://udemy.com/user/thiagobrandam/";

    expect(validator(url)).toEqual({
      valid: false,
      value: undefined,
      originalValue: url
    });
  });
});
