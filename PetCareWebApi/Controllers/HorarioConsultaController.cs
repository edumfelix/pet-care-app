using Microsoft.AspNetCore.Mvc;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Repository;

namespace PetCareWebApi.Controllers
    {
    [Route("api/v1/[controller]")]
    [ApiController]
    public class HorarioConsultaController : ControllerBase
    {
        private readonly IHorarioConsultaRepository _repository;
        private readonly ILogger<HorarioConsultaController> _logger;

        public HorarioConsultaController(IHorarioConsultaRepository repository, ILogger<HorarioConsultaController> logger)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<HorarioConsultaVO>>> FindAll()
        {
            try
            {
                var horarioConsultas = await _repository.FindAll();
                return Ok(horarioConsultas);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao buscar todos os horários de consulta");
                return StatusCode(500, "Erro interno no servidor");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<HorarioConsultaVO>> FindById(long id)
        {
            try
            {
                var horarioConsulta = await _repository.FindById(id);
                if (horarioConsulta == null)
                {
                    _logger.LogWarning("Horário de consulta com ID {Id} não encontrado", id);
                    return NotFound();
                }
                return Ok(horarioConsulta);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao buscar horário de consulta com ID {Id}", id);
                return StatusCode(500, "Erro interno no servidor");
            }
        }

        [HttpPost]
        public async Task<ActionResult<HorarioConsultaVO>> Create(HorarioConsultaVO vo)
        {
            if (vo == null)
            {
                _logger.LogWarning("Tentativa de criação de horário de consulta com objeto nulo");
                return BadRequest();
            }
            try
            {
                var horarioConsulta = await _repository.Create(vo);
                return Ok(horarioConsulta);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao criar horário de consulta");
                return StatusCode(500, "Erro interno no servidor");
            }
        }

        [HttpPut]
        public async Task<ActionResult<HorarioConsultaVO>> Update(HorarioConsultaVO vo)
        {
            if (vo == null)
            {
                _logger.LogWarning("Tentativa de atualização de horário de consulta com objeto nulo");
                return BadRequest();
            }
            try
            {
                var horarioConsulta = await _repository.Update(vo);
                return Ok(horarioConsulta);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao atualizar horário de consulta");
                return StatusCode(500, "Erro interno no servidor");
            }
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(long id)
        {
            try
            {
                var status = await _repository.Delete(id);
                if (!status)
                {
                    _logger.LogWarning("Tentativa de exclusão de horário de consulta com ID {Id} não encontrado", id);
                    return BadRequest();
                }
                return Ok(status);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Erro ao excluir horário de consulta com ID {Id}", id);
                return StatusCode(500, "Erro interno no servidor");
            }
        }
    }
}
