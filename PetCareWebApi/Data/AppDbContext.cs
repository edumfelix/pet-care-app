using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Models;
using System;

namespace PetCareWebApi.Data
{
    public class AppDbContext : IdentityDbContext<User>, IAppDbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Consulta> Consultas { get; set; }
        public DbSet<HorarioConsulta> HorarioConsultas { get; set; }

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            return await base.SaveChangesAsync(cancellationToken);
        }
    }
}