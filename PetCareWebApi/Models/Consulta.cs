using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Models.Base;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetCareWebApi.Models
    {

    [Table("consulta")]
    public class Consulta : BaseEntity
        {
        [Column("horario")]
        [Required]
        public long? IdHorario { get; set; }

        [Column("idVeterinario")]
        [Required]
        public string? IdVeterinario { get; set; }

        [Column("idTutor")]
        [Required]
        public string? IdTutor { get; set; }
        }
    }
