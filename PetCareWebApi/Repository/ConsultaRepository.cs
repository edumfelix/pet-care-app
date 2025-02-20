using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Data;
using PetCareWebApi.Models;
using PetCareWebApi.Patterns.Observer.Base;

namespace PetCareWebApi.Repository
    {
    public class ConsultaRepository : IConsultaRepository
    {
        private readonly IAppDbContext _context;
        private ILogger _logger;

        public ConsultaRepository(IAppDbContext context, ILogger<ConsultaRepository> logger)
            {
            _context = context;
            _logger = logger;
            }

        public async Task<Consulta> Create(Consulta consulta)
        {
            _context.Consultas.Add(consulta);
            await _context.SaveChangesAsync();
            return consulta;
        }

        public async Task<bool> Delete(long id)
        {
            try
            {
                var consulta = await _context.Consultas.FirstOrDefaultAsync(s => s.Id == id);

                if (consulta == null)
                    return false;

                _context.Consultas.Remove(consulta);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro inesperado ao excluir a consulta com ID {Id}", id);
                throw;
            }
        }

        public async Task<IEnumerable<Consulta>> FindAll() 
            {
            return await _context.Consultas.ToListAsync();
        }
        public async Task<Consulta> FindById(long id)
        {
            var consulta = await _context.Consultas.FirstOrDefaultAsync(s => s.Id == id);
            if (consulta == null)
                throw new KeyNotFoundException($"Consulta com ID {id} não encontrada.");
            return consulta;
        }

        public async Task<Consulta> Update(Consulta consulta) 
            {
            _context.Consultas.Update(consulta);
            await _context.SaveChangesAsync();
            return consulta;
        }
        
        }
    }