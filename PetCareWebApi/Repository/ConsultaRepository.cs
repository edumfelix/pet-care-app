using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Data;
using PetCareWebApi.Models;
using PetCareWebApi.Patterns.Observer.Base;

namespace PetCareWebApi.Repository
    {
    public class ConsultaRepository : NotificationSubject,IConsultaRepository
    {
        private readonly AppDbContext _context;
        private IMapper _mapper;
        private ILogger _logger;

        public ConsultaRepository(AppDbContext context, IMapper mapper, ILogger<ConsultaRepository> logger)
            {
            _context = context;
            _mapper = mapper;
            _logger = logger;
            }

        public async Task<ConsultaVO> Create(ConsultaVO vo)
        {
            Consulta consulta = _mapper.Map<Consulta>(vo);
            _context.Consultas.Add(consulta);
            await _context.SaveChangesAsync();

            // Notificar observers
            var consultaVO = _mapper.Map<ConsultaVO>(consulta);
            await NotifyObservers("Consulta Criada", consultaVO);

            return consultaVO;
        }

        public async Task<bool> Delete(long id)
        {
            try
            {
                var consulta = await _context.Consultas.FirstOrDefaultAsync(s => s.Id == id);

                if (consulta == null)
                    return false;

                _context.Consultas.Remove(consulta);
                await _context.SaveChangesAsync(true);
                return true;
            }
            catch (DbUpdateException ex)
            {
                _logger.LogError(ex, "Erro ao excluir a consulta com ID {Id}", id);
                throw new ApplicationException("Erro ao excluir a consulta.", ex);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro inesperado ao excluir a consulta com ID {Id}", id);
                throw;
            }
        }

        public async Task<IEnumerable<ConsultaVO>> FindAll() 
            {
            List<Consulta> consultas = await _context.Consultas.ToListAsync();
            return _mapper.Map<List<ConsultaVO>>(consultas);
            }
        public async Task<ConsultaVO> FindById(long id) 
            {
            Consulta? consulta = await _context.Consultas
                .Where(s => s.Id == id)
                .FirstOrDefaultAsync();

            return _mapper.Map<ConsultaVO>(consulta);
            }

        public async Task<ConsultaVO> Update(ConsultaVO vo) 
            {
            Consulta consulta = _mapper.Map<Consulta>(vo);
            _context.Consultas.Update(consulta);
            await _context.SaveChangesAsync();
            return _mapper.Map<ConsultaVO>(consulta);
            }
        
        }
    }