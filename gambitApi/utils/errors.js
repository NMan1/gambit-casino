export const internalServerError = (res, err = null) => {
  if (err !== null) {
    console.log(err);
  }

  return res.status(404).json({
    code: "SERVER_ERROR",
    message: "Internal server error, try again later",
  });
};

export const generateErrorResponse = (res, code, msg) => {
  return res.status(404).json({
    code: code,
    message: msg,
  });
};
