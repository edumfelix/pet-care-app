using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Models;
using System;

namespace PetCareWebApi.Data
{
    public class AppDbContext : IdentityDbContext<User>
        {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Consulta> Consultas { get; set; }
        public DbSet<Dieta> Dietas { get; set; }
        public DbSet<HorarioConsulta> HorarioConsultas { get; set; }
        }
}
