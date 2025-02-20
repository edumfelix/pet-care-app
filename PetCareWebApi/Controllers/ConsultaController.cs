using Microsoft.AspNetCore.Mvc;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Models;
using PetCareWebApi.Patterns.Observer.Base;
using PetCareWebApi.Repository;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PetCareWebApi.Controllers
{
    [Route("api/v1/[controller]")]
    [ApiController]
    public class ConsultaController : ControllerBase
    {
        private readonly IConsultaRepository _repository;
        private readonly NotificationSubject _notificationSubject;
        private readonly ILogger<ConsultaController> _logger;

        public ConsultaController(IConsultaRepository repository, NotificationSubject notificationSubject, ILogger<ConsultaController> logger)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _notificationSubject = notificationSubject ?? throw new ArgumentNullException(nameof(notificationSubject));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ConsultaVO>>> FindAll()
        {
            try
            {
                var consultas = await _repository.FindAll();
                return Ok(consultas);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao buscar todas as consultas.");
                return StatusCode(500, "Erro interno do servidor.");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ConsultaVO>> FindById(long id)
        {
            try
            {
                var consulta = await _repository.FindById(id);
                if (consulta == null)
                    return NotFound();
                return Ok(consulta);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao buscar consulta com ID {Id}", id);
                return StatusCode(500, "Erro interno do servidor.");
            }
        }

        [HttpPost]
        public async Task<ActionResult<Consulta>> Create(Consulta consulta)
        {
            try
            {
                if (consulta == null)
                    return BadRequest("Dados inválidos.");

                var consultaCriada = await _repository.Create(consulta);
                _logger.LogInformation("Consulta criada com sucesso: {ConsultaId}", consultaCriada.Id);

                await _notificationSubject.NotifyObservers("Consulta Criada", consultaCriada);

                return Ok(consultaCriada);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao criar consulta.");
                return StatusCode(500, "Erro interno do servidor.");
            }
        }

        [HttpPut]
        public async Task<ActionResult<Consulta>> Update(Consulta consulta)
        {
            try
            {
                if (consulta == null)
                    return BadRequest("Dados inválidos.");

                var consultaAtualizada = await _repository.Update(consulta);
                return Ok(consultaAtualizada);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao atualizar consulta.");
                return StatusCode(500, "Erro interno do servidor.");
            }
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(long id)
        {
            try
            {
                var status = await _repository.Delete(id);
                if (!status)
                    return BadRequest("Não foi possível excluir a consulta.");
                return Ok(status);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao excluir consulta com ID {Id}", id);
                return StatusCode(500, "Erro interno do servidor.");
            }
        }
    }
}
