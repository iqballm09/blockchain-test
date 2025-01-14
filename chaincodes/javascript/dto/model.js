const userSchema = {
    type: "object",
    properties: {
      name: { type: "string" },
      email: { type: "string" },
      saldo: { type: "number" },
      isAdmin: { type: "boolean" },
    },
    required: ["name", "email", "saldo"],
  };
  
  module.exports = { userSchema };