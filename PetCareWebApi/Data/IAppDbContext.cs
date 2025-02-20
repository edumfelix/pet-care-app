using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Models;
using System.Threading;
using System.Threading.Tasks;

namespace PetCareWebApi.Data
{
    public interface IAppDbContext
    {
        DbSet<Consulta> Consultas { get; }
        DbSet<HorarioConsulta> HorarioConsultas { get; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    }
}
