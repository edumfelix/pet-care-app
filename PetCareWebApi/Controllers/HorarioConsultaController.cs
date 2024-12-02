using Microsoft.AspNetCore.Mvc;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Repository;

namespace PetCareWebApi.Controllers
    {
    [Route("api/v1/[controller]")]
    [ApiController]
    public class HorarioConsultaController : ControllerBase
        {
        private IHorarioConsultaRepository _repository;
        public HorarioConsultaController(IHorarioConsultaRepository repository)
            {
            _repository = repository ?? throw new
                ArgumentNullException(nameof(repository));
            }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<HorarioConsultaVO>>> FindAll()
            {
            var horarioConsultas = await _repository.FindAll();
            return Ok(horarioConsultas);
            }

        [HttpGet("{id}")]
        public async Task<ActionResult<HorarioConsultaVO>> FindById(long id)
            {
            var horarioConsulta = await _repository.FindById(id);
            if (horarioConsulta == null)
                return NotFound();
            return Ok(horarioConsulta);
            }
        [HttpPost]
        public async Task<ActionResult<HorarioConsultaVO>> Create(HorarioConsultaVO vo)
            {
            if (vo == null)
                return BadRequest();
            var horarioConsulta = await _repository.Create(vo);
            return Ok(horarioConsulta);
            }
        [HttpPut]
        public async Task<ActionResult<HorarioConsultaVO>> Update(HorarioConsultaVO vo)
            {
            if (vo == null)
                return BadRequest();
            var horarioConsulta = await _repository.Update(vo);
            return Ok(horarioConsulta);
            }
        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(long id)
            {
            var status = await _repository.Delete(id);
            if (!status)
                return BadRequest();
            return Ok(status);
            }
        }
    }
    
