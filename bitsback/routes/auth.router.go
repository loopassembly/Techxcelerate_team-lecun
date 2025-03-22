

package routes

import (
	"github.com/gofiber/fiber/v2"
)

func AuthRouter(app *fiber.App) {
 auth := app.Group("/auth")

 controller := NewAuthController()

 auth.Post("/login", controller.Login)
 auth.Post("/register", controller.Register)
 auth.Post("/forgot-password", controller.ForgotPassword) 
 auth.Post("/reset-password", controller.ResetPassword)
}