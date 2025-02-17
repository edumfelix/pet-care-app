using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using PetCareWebApi.Models;
using PetCareWebApi.Services;

namespace PetCareWebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly SignInManager<User> _signInManager;
        private readonly TokenService _tokenService;

        public AuthController(
            UserManager<User> userManager,
            SignInManager<User> signInManager,
            TokenService tokenService)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _tokenService = tokenService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginModel model)
        {
            // Valida se o email ou a senha estão vazios ou nulos
            if (string.IsNullOrEmpty(model.Email))
                return BadRequest("Email is required.");
            if (string.IsNullOrEmpty(model.Password))
                return BadRequest("Password is required.");

            // Tenta encontrar o usuário pelo email
            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
                return Unauthorized("Invalid email or password");

            // Valida as credenciais com o SignInManager
            var result = await _signInManager.CheckPasswordSignInAsync(user, model.Password, false);
            if (!result.Succeeded)
                return Unauthorized("Invalid email or password");

            // Gera o token JWT
            var token = TokenService.GenerateToken(user);  // Correção: chamado pela classe TokenService

            // Retorna o token gerado
            return Ok(new { token });
        }

    }
}
