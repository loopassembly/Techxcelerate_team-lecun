package controllers

import (
 "time"
 "github.com/dgrijalva/jwt-go"
 "github.com/gofiber/fiber/v2"
 "golang.org/x/crypto/bcrypt"
)

type AuthController struct {
 
}

type LoginRequest struct {
 Email    string `json:"email"`
 Password string `json:"password"`
}

type RegisterRequest struct {
 Name     string `json:"name"`
 Email    string `json:"email"` 
 Password string `json:"password"`
}

type ForgotPasswordRequest struct {
 Email string `json:"email"`
}

type ResetPasswordRequest struct {
 Token    string `json:"token"`
 Password string `json:"password"`
}

func NewAuthController() *AuthController {
 return &AuthController{}
}

func (c *AuthController) Login(ctx *fiber.Ctx) error {
 var req LoginRequest
 if err := ctx.BodyParser(&req); err != nil {
  return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
   "error": "Invalid request",
  })
 }


 if req.Email != "test@example.com" || req.Password != "password" {
  return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
   "error": "Invalid credentials",
  })
 }


 token := jwt.New(jwt.SigningMethodHS256)
 claims := token.Claims.(jwt.MapClaims)
 claims["email"] = req.Email
 claims["exp"] = time.Now().Add(time.Hour * 72).Unix()

 t, err := token.SignedString([]byte("secret"))
 if err != nil {
  return ctx.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
   "error": "Could not generate token",
  })
 }

 return ctx.JSON(fiber.Map{
  "token": t,
 })
}

func (c *AuthController) Register(ctx *fiber.Ctx) error {
 var req RegisterRequest
 if err := ctx.BodyParser(&req); err != nil {
  return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
   "error": "Invalid request",
  })
 }

 

 return ctx.JSON(fiber.Map{
  "message": "User registered successfully",
 })
}

func (c *AuthController) ForgotPassword(ctx *fiber.Ctx) error {
 var req ForgotPasswordRequest
 if err := ctx.BodyParser(&req); err != nil {
  return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
   "error": "Invalid request",
  })
 }



 return ctx.JSON(fiber.Map{
  "message": "Reset password instructions sent to email",
 })
}

func (c *AuthController) ResetPassword(ctx *fiber.Ctx) error {
 var req ResetPasswordRequest
 if err := ctx.BodyParser(&req); err != nil {
  return ctx.Status(fiber.StatusBadRequest).JSON(fiber.Map{
   "error": "Invalid request", 
  })
 }

 

 return ctx.JSON(fiber.Map{
  "message": "Password reset successfully",
 })
}