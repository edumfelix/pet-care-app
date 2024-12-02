using Microsoft.AspNetCore.Mvc;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Repository;

namespace PetCareWebApi.Controllers
    {
    [Route("api/v1/[controller]")]
    [ApiController]
    public class ConsultaController : ControllerBase
        {
        private IConsultaRepository _repository;
        public ConsultaController(IConsultaRepository repository)
            {
            _repository = repository ?? throw new
                ArgumentNullException(nameof(repository));
            }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ConsultaVO>>> FindAll()
            {
            var consultas = await _repository.FindAll();
            return Ok(consultas);
            }

        [HttpGet("{id}")]
        public async Task<ActionResult<ConsultaVO>> FindById(long id)
            {
            var consulta = await _repository.FindById(id);
            if (consulta == null)
                return NotFound();
            return Ok(consulta);
            }
        [HttpPost]
        public async Task<ActionResult<ConsultaVO>> Create(ConsultaVO vo)
            {
            if (vo == null)
                return BadRequest();
            var consulta = await _repository.Create(vo);
            return Ok(consulta);
            }
        [HttpPut]
        public async Task<ActionResult<ConsultaVO>> Update(ConsultaVO vo)
            {
            if (vo == null)
                return BadRequest();
            var consulta = await _repository.Update(vo);
            return Ok(consulta);
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
