package main
import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/helmet"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"log"
	"proback/routes"
)

func main() {
	app := fiber.New(fiber.Config{
		AppName:      "My Fiber App",
		ServerHeader: "Fiber", 
		Prefork:      true,
	})

	// Middleware
	app.Use(helmet.New())
	app.Use(logger.New())
	app.Use(recover.New())
	app.Use(cors.New(cors.Config{
		AllowOrigins:     "*",
		AllowMethods:     "GET,POST,PUT,DELETE,OPTIONS",
		AllowHeaders:     "Origin, Content-Type, Accept, Authorization",
		AllowCredentials: true,
		ExposeHeaders:    "Content-Length",
		MaxAge:           86400,
	}))

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Hello, BitsHack!")
	})


	routes.AuthRouter(app)


	if err := app.Listen(":3000"); err != nil {
		log.Fatal(err)
	}
}
