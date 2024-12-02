using Microsoft.AspNetCore.Mvc;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Repository;

namespace PetCareWebApi.Controllers
    {
    [Route("api/v1/[controller]")]
    [ApiController]
    public class DietaController : ControllerBase
        {
        private IDietaRepository _repository;
        public DietaController(IDietaRepository repository)
            {
            _repository = repository ?? throw new
                ArgumentNullException(nameof(repository));
            }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<DietaVO>>> FindAll()
            {
            var dietas = await _repository.FindAll();
            return Ok(dietas);
            }

        [HttpGet("{id}")]
        public async Task<ActionResult<DietaVO>> FindById(long id)
            {
            var dieta = await _repository.FindById(id);
            if (dieta == null)
                return NotFound();
            return Ok(dieta);
            }
        [HttpPost]
        public async Task<ActionResult<DietaVO>> Create(DietaVO vo)
            {
            if (vo == null)
                return BadRequest();
            var dieta = await _repository.Create(vo);
            return Ok(dieta);
            }
        [HttpPut]
        public async Task<ActionResult<DietaVO>> Update(DietaVO vo)
            {
            if (vo == null)
                return BadRequest();
            var dieta = await _repository.Update(vo);
            return Ok(dieta);
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