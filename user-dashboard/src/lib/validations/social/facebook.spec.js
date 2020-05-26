import { validator } from "./facebook";

describe("facebook id validator", () => {
  it("accepts valid id", () => {
    const id = "nethan.petrolie";

    expect(validator(id)).toEqual({
      valid: true,
      value: "https://www.facebook.com/nethan.petrolie",
      originalValue: id
    });
  });

  it("accepts valid url with vanity id", () => {
    const url = "https://facebook.com/nethan.petrolie/";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://www.facebook.com/nethan.petrolie",
      originalValue: url
    });
  });

  it("accepts valid url with vanity id", () => {
    const url = "https://facebook.com/100018839703689";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://www.facebook.com/100018839703689",
      originalValue: url
    });
  });

  it("accepts profile.php?id format", () => {
    const url = "https://www.facebook.com/profile.php?id=100018839703689";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://www.facebook.com/100018839703689",
      originalValue: url
    });
  });

  it("accepts unicode ids", () => {
    const id = "로지아-출산연구소-518672775193040";

    expect(validator(id)).toEqual({
      valid: true,
      value:
        "https://www.facebook.com/%EB%A1%9C%EC%A7%80%EC%95%84-%EC%B6%9C%EC%82%B0%EC%97%B0%EA%B5%AC%EC%86%8C-518672775193040",
      originalValue: id
    });
  });

  it("accepts valid url with www", () => {
    const url = "https://www.facebook.com/nethan.petrolie";

    expect(validator(url)).toEqual({
      valid: true,
      value: "https://www.facebook.com/nethan.petrolie",
      originalValue: url
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
