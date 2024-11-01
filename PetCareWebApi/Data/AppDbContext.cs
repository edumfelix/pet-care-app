using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Models;

namespace PetCareWebApi.Data
{
    public class AppDbContext(DbContextOptions options) 
        : IdentityDbContext <User>(options);
}
